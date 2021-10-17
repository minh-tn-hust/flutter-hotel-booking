import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

enum ApplicationLoginState {
  login,
  loggedOut,
  register,
  user,
  host,
  admin,
  baned,
  resetPassword,
  confirmResetCode,
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        switch (user.displayName) {
          case "User":
            _loginState = ApplicationLoginState.user;
            print("ApplicationState - init() - user = $user");
            initCustomer(user.uid);
            break;
          case "Host":
            _loginState = ApplicationLoginState.host;
            print("ApplicationState - init() - user = $user");
            initCustomer(user.uid);
            break;
          case "Admin":
            _loginState = ApplicationLoginState.admin;
            break;
          case "HostBaned":
            _loginState = ApplicationLoginState.baned;
            break;
          case "UserBaned":
            _loginState = ApplicationLoginState.baned;
            break;
        }
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      return "Done";
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return (error.message.toString());
    }
  }

  Future<String> changePassword(
      String old, String newPassword, String confirmPassword) async {
    var getUser = user;
    print("Auth-stat = changePassword - $user");
    var authCredential =
        EmailAuthProvider.credential(email: getUser!.email!, password: old);
    print("Authstate - ChangePassword - authCredential = $authCredential");
    try {
      var authResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
      print("Authstate - ChangePassword - authResult = $authResult");
      if (authResult.user != null) {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        return "Done";
      } else {
        return "Old password not match";
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code.toString()) {
        case "wrong-password":
          return "Your old password is invalid, please try again";
        default:
          print(error.message);
          return error.message!;
      }
    }
  }

  void getResetEmail() {
    _loginState = ApplicationLoginState.resetPassword;
    notifyListeners();
  }

  void acceptResetEmail() {
    _loginState = ApplicationLoginState.confirmResetCode;
    notifyListeners();
  }

  Future<Map<String, String>> checkCard(CreditCard userCard) async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/checkCard?cardNumber=${userCard.number}&holder=${userCard.name}&expMonth=${userCard.expMonth}&expYear=${userCard.expYear}&cvc=${userCard.cvc}"));
      var getRes = jsonDecode(res.body);
      if (getRes["status"] == "Error") return {"Error": getRes["error"]};
      if (getRes["status"] == "Done") {
        return {"Done": "Done"};
      }
      return {"Error": "Somethings wrong in our process"};
    } on HttpException catch (e) {
      return {"Error": e.message};
    }
  }

  Future<Map<String, String>> createCardForNewCustomer(
      CreditCard userCard) async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/createNewUserWithCard?cardNumber=${userCard.number}&holder=${userCard.name}&expMonth=${userCard.expMonth}&expYear=${userCard.expYear}&cvc=${userCard.cvc}&uid=${user!.uid}"));
      var getRes = jsonDecode(res.body);
      if (getRes["status"] == "Error") return {"Error": getRes["error"]};
      if (getRes["status"] == "Done") {
        await initCustomer(user!.uid);
        return {"Done": "Done"};
      }
      return {"Error": "Somethings wrong in our process"};
    } on HttpException catch (e) {
      return {"Error": e.message};
    }
  }

  Future<Map<String, String>> updateCustomerCard(CreditCard creditCard) async {
    // Đầu tiên nhờ server tạo token -> Lấy fingerPrint trước
    print("============================UPDATECUSTOMERCARD===========");
    User getUser = FirebaseAuth.instance.currentUser!;
    try {
      print(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/cretateCardForUser?cardNumber=${creditCard.number}&expMonth=${creditCard.expMonth}&expYear=${creditCard.expYear}&holder=${creditCard.name}&cvc=${creditCard.cvc}&uid=${getUser.uid}");
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/cretateCardForUser?cardNumber=${creditCard.number}&expMonth=${creditCard.expMonth}&expYear=${creditCard.expYear}&holder=${creditCard.name}&cvc=${creditCard.cvc}&uid=${getUser.uid}"));
      var response = jsonDecode(res.body);
      print("updateCustomerCard - FirebaseService - $response");
      if (response["status"] == "Error") {
        return {"Error": response["error"], "Done": "Error"};
      } else {
        await initCustomer(getUser.uid);
        return {"Done": "Done"};
      }
    } on HttpException catch (error) {
      print("updateCustomerCard - Error - ${error.message}");
      return {"Error": error.message, "Done": "Error"};
    }
  }

  void change(String field, String val) async {
    switch (field) {
      case "Email":
        customerInfo!.email = val;
        FirebaseService.instance().update("email", val, user!.uid);
        break;
      case "Last Name":
        customerInfo!.lastName = val;
        FirebaseService.instance().update("lastName", val, user!.uid);
        break;
      case "First Name":
        customerInfo!.firstName = val;
        FirebaseService.instance().update("firstName", val, user!.uid);
        break;
      case "Post Code":
        customerInfo!.postcode = val;
        FirebaseService.instance().update("postCode", val, user!.uid);
        break;
      case "Phone number":
        customerInfo!.mobile = val;
        FirebaseService.instance().update("mobile", val, user!.uid);
        break;
    }
  }

  Future<void> initCustomer(String uid) async {
    print("init CustomerInfo called");
    var customerRef =
        await FirebaseFirestore.instance.collection("userInfo").doc(uid).get();
    while (customerRef.data() == null) {
      print("Hello");
      customerRef = await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(uid)
          .get();
    }
    print("this is customerRef : ${customerRef.data()}");
    customerInfo =
        CustomerInfo.fromJson(customerRef.data() as Map<String, dynamic>);
    print(customerInfo.toString());
    // notifyListeners();
  }

  CustomerInfo? customerInfo;
  User? get user => FirebaseAuth.instance.currentUser;
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
    bool canBack,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user!.displayName == "User" ||
          credential.user!.displayName == "Host") {
        await initCustomer(credential.user!.uid);
        Navigator.of(context).pop();

        if (canBack) Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
      errorCallback(e);
    }
  }

  Future<void> registerAccount(
    String email,
    String role,
    String password,
    BuildContext context,
    bool canBack,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateProfile(displayName: role);
      // nếu như là người dùng sẽ ẩn đi, nếu như là host,
      // đối tượng của class này sẽ lắng nghe sự thay đổi thành host ->
      //loginScreen sẽ ở trạng thái là ApplicationLoginState.host
      if (role == "User" || role == "Host") {
        await initCustomer(credential.user!.uid);
        Navigator.of(context).pop();
        if (canBack) Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
      errorCallback(e);
    }
  }

  Future<String> checkResetPasswordCode(String code) async {
    try {
      var checkMail = await FirebaseAuth.instance.checkActionCode(code);
      print(checkMail);
      return (checkMail.toString());
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  void logOut() {
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }

  Future<String> checkMail(String email) async {
    try {
      var checkmail =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (!checkmail.contains('password')) {
        return "Done";
      } else
        return "Fail";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  void register() {
    _loginState = ApplicationLoginState.register;
    notifyListeners();
  }

  void login() {
    _loginState = ApplicationLoginState.login;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.login;
    customerInfo = null;
    notifyListeners();
  }
}
