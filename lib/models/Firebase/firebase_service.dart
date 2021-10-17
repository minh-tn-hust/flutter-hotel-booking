import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';
import 'package:latlong2/latlong.dart';

class FirebaseService {
  static FirebaseService instance() {
    return new FirebaseService();
  }

  CollectionReference hotelLatLng =
      FirebaseFirestore.instance.collection("hotelLatLng");
  CollectionReference hotelWithInfo =
      FirebaseFirestore.instance.collection("hotelWithInfo");
  CollectionReference userInfo =
      FirebaseFirestore.instance.collection("userInfo");
  // Host ======================================================
  Future<List<Hotel>> loadHotelWithUId(String userID) async {
    List<Hotel> ans = [];
    ans = await hotelWithInfo
        .where('hostID', isEqualTo: userID.toString())
        .get()
        .then((dr) => dr.docs.map((e) {
              var hotel = Hotel.fromJson(e.data() as Map<String, dynamic>);
              hotel.hotelID = e.id;
              return hotel;
            }).toList());
    return ans;
  }

  Future<List<Hotel>> loadRecommendHotel() async {
    print("Call loadRecommendHotel");
    List<Hotel> hotel = [];
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/loadRecommendHotel"));
      var list = (jsonDecode(res.body) as Map<String, dynamic>)["id"];
      for (int i = 0; i < list.length; i++) {
        String hotelId = list[i];
        var data = (await hotelWithInfo.doc(hotelId).get()).data();
        var hotelRef = Hotel.fromJson(data as Map<String, dynamic>);
        hotelRef.hotelID = list[i];
        if (hotelRef.verify == true) hotel.add(hotelRef);
      }
      return hotel;
    } on Exception catch (e) {
      print("Error = ${e.toString()}");
      return [];
    }
  }

  // LOAD HISTORY CHO CUSTOMER Ở CHỖ NÀY NÈ

  Future<List<dynamic>> loadHistoryFromUser(String userId) async {
    List<dynamic> ans = [];
    ans = await FirebaseFirestore.instance
        .collection("history")
        .where("uid", isEqualTo: userId)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.map((e) => e.data()["id"]).toList());
    print(ans);
    return ans;
  }

  Future<Map<String, dynamic>> getHistoreyInfo(String docId) async {
    print("this is $docId");
    var res = await FirebaseFirestore.instance
        .collection("paymentIntent")
        .doc(docId)
        .get();
    print("this Is ${res.data()}");
    return res.data()!;
  }

  //User

  // Cập nhật thông tin cho user
  void update(String field, String val, String uid) async {
    await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(uid)
        .update({field: val});
  }

  Future<List<Hotel>> loadAllHotel() async {
    List<Hotel> ans = [];
    try {
      ans = await hotelWithInfo
          .get()
          .then((querySnapshot) => querySnapshot.docs.map((e) {
                var result = Hotel.fromJson(e.data() as Map<String, dynamic>);
                result.hotelID = e.id;
                return result;
              }).toList());
    } on FirebaseException catch (e) {
      print("AAAAAAAAAAAAAAAAAA ${e.message}");
    }
    return ans;
  }

  Future<List<Hotel>> loadHotelWithCondition(
    SearchInfoModel searchModel,
    void Function(FirebaseException e) voidCallBack,
  ) async {
    // in 10 km
    var minPrice = searchModel.minPrice;
    var maxPrice = searchModel.maxPrice;
    var type = searchModel.type;
    var distance = searchModel.maxDistance! * 1000;
    List<Hotel?> ans = [];
    try {
      ans = await hotelWithInfo
          .get()
          .then((querySnapshot) => querySnapshot.docs.map((e) {
                var json = e.data() as Map<String, dynamic>;
                print(json["verity"]);
                if (json["verity"] == true) {
                  int R = 6371000;
                  double p1 =
                      searchModel.location!.coordinates.latitude * pi / 180;
                  double p2 =
                      json["location"]["coordinates"]["latitude"] * pi / 180;
                  double dentap = (p2 - p1);
                  double dental = (json["location"]["coordinates"]
                              ["longtitude"] -
                          searchModel.location!.coordinates.longitude) *
                      (pi / 180);
                  double a = sin(dentap / 2) * sin(dentap / 2) +
                      cos(p1) * cos(p2) * sin(dental / 2) * sin(dental / 2);
                  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
                  double d = R * 1.0 * c;
                  if (d < distance &&
                      json["lowestPrice"]! >= minPrice &&
                      json["lowestPrice"]! <= maxPrice &&
                      (json["type"] == type || type == 2)) {
                    Hotel check = Hotel.fromJson(json);
                    check.distance = d;
                    check.hotelID = e.id;
                    return check;
                  } else
                    return null;
                } else
                  return null;
              }).toList());
    } on FirebaseException catch (e) {
      voidCallBack(e);
    }
    List<Hotel> result = [];
    for (var record in ans) {
      if (record != null) result.add(record);
    }
    return result;
  }

  Future<int> checkColusion(
    String hotelId,
    String roomId,
    DateTime? beginDate,
    DateTime? endDate,
    int roomAvailabe,
  ) async {
    if (beginDate == null && endDate == null) {
      return -1;
    }
    var begin = Timestamp.fromDate(beginDate!).seconds;
    var end = Timestamp.fromDate(endDate!).seconds;
    try {
      print(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/checkColusion?hotelId=$hotelId&roomId=$roomId&beginDate=$begin&endDate=$end");
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/checkColusion?hotelId=$hotelId&roomId=$roomId&beginDate=$begin&endDate=$end"));
      var colusion = jsonDecode(res.body)["colusion"];
      print("colusion = $colusion");
      print("roomAvaiable = $roomAvailabe");
      if (colusion < roomAvailabe) {
        return colusion;
      }
    } catch (error) {
      print(error);
    }
    return -2;
  }

  Future<List<String>> getClientSecret(
      int amount, String destination, String userID, String pmID) async {
    try {
      var response = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/getClientSecret?amount=$amount&destination=$destination&userID=$userID&pmID=$pmID"));
      var result = jsonDecode(response.body);
      print(result);
      return [result["result"], result["paymentMethod"]];
    } catch (e) {
      print("Wtf loi gi day ${e.toString()}");
    }
    return ["Error", "Error"];
  }

  Future<String> createCardForNewUser(CreditCard userCard, User user) async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/createNewUserWithCard?cardNumber=${userCard.number}&holder=${userCard.name}&expMonth=${userCard.expMonth}&expYear=${userCard.expYear}&cvc=${userCard.cvc}&uid=${user.uid}"));
      var getRes = jsonDecode(res.body);
      print("FirebaseService -createCardForNewUser - getId =  ${getRes["id"]}");
      return "Success";
    } on HttpException catch (e) {
      return e.message;
    }
  }

  //======================== PAY IS HERE ==============================================///
  Future<String> pay(int amout, String paymentMethodId, User user,
      CustomerInfo customerInfo, SearchModel searchModel) async {
    var hotel = searchModel.pickHotel;
    var room = searchModel.pickRoom;
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51J0pA5COvGgqIugFXnx8ZG3zRU8KwUabx9E5zmuZTtw7NffB1XjROc1dNOBcBTH1Ztm85O7WRLog9GVL3j4v3vhE00UIcBwUFA",
        merchantId: "Test",
        androidPayMode: 'test'));
    var paymentIntentResult =
        await createAndConfirm(amout, hotel!, user, paymentMethodId);
    if (paymentIntentResult.status == "succeeded") {
      // Cập nhật thông tin thanh toán của khách hàng về server
      print("Payment success");
      return await updateAfterPay(
          paymentIntentResult, hotel, room!, searchModel, user);
    } else
      return "Fail to pay";
    // nếu như mà confirm thành công thì mình sẽ attach cái paymentMethod hiện tại với cái custommer của người dùng
  }

  Future<String> firstPay(
    int amount,
    CreditCard userCard,
    CustomerInfo customerInfo,
    User user,
    SearchModel searchModel,
  ) async {
    var hotel = searchModel.pickHotel;
    var room = searchModel.pickRoom;
    userCard.addressCountry = customerInfo.country;
    String getError = "";
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51J0pA5COvGgqIugFXnx8ZG3zRU8KwUabx9E5zmuZTtw7NffB1XjROc1dNOBcBTH1Ztm85O7WRLog9GVL3j4v3vhE00UIcBwUFA",
        merchantId: "Test",
        androidPayMode: 'test'));
    PaymentIntentResult? paymentIntentResult;
    // return "OK";

    // thêm thông tin về card mà người dùng nhập vào
    print("Add token");
    String? paymentMethodId;
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/createNewUserWithCard?cardNumber=${userCard.number}&holder=${userCard.name}&expMonth=${userCard.expMonth}&expYear=${userCard.expYear}&cvc=${userCard.cvc}&uid=${user.uid}"));
      var getRes = jsonDecode(res.body);
      print(getRes);
      paymentMethodId = getRes["id"];
      print(paymentMethodId);
    } on HttpException catch (e) {
      print(e.message);
      getError = e.message;
    }
    if (getError != "") {
      return getError;
    }
    if (getError != "") return getError;

    // update thông tin người dùng vừa khai
    try {
      await FirebaseFirestore.instance
          .collection("userInfo")
          .doc(user.uid)
          .update(customerInfo.toJson());
    } on FirebaseException catch (error) {
      getError = error.message!;
    }
    if (getError != "") return getError;

    return await Future.delayed(Duration(seconds: 5), () async {
      paymentIntentResult =
          await createAndConfirm(amount, hotel!, user, paymentMethodId!);

      if (paymentIntentResult!.status == "succeeded") {
        // Cập nhật thông tin thanh toán của khách hàng về server
        print("Payment success");
        return await updateAfterPay(
            paymentIntentResult!, hotel, room!, searchModel, user);
      } else
        return "Fail to pay";
      // nếu như mà confirm thành công thì mình sẽ attach cái paymentMethod hiện tại với cái custommer của người dùng
    });
  }

  Future<PaymentIntentResult> createAndConfirm(
    int amount,
    Hotel hotel,
    User user,
    String paymentMethodId,
  ) async {
    List<String>
        paymentIntentClientSecret = // tạo PaymentIntent luôn để trả tiền luôn
        await getClientSecret(
            amount, hotel.destination!, user.uid, paymentMethodId);
    print(paymentIntentClientSecret);
    PaymentIntentResult? paymentIntentResult;
    // confirm thông tin vừa được tạo
    try {
      StripePayment.setOptions(StripeOptions(
          publishableKey:
              "pk_test_51J0pA5COvGgqIugFXnx8ZG3zRU8KwUabx9E5zmuZTtw7NffB1XjROc1dNOBcBTH1Ztm85O7WRLog9GVL3j4v3vhE00UIcBwUFA",
          merchantId: "Test",
          androidPayMode: 'test'));
      await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntentClientSecret[0],
          paymentMethodId: paymentIntentClientSecret[1],
        ),
      ).then((value) {
        paymentIntentResult = value;
      });
    } catch (error) {
      print("Checkout error $error");
    }
    print(paymentIntentResult!.toJson());
    return paymentIntentResult!;
  }

  Future<String> updateAfterPay(PaymentIntentResult paymentIntentResult,
      Hotel hotel, Room room, SearchModel searchModel, User user) async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/updatePayment?clientSecret=${paymentIntentResult.paymentIntentId}&hotelID=${hotel.hotelID}&roomId=${room.id}"));
      var getDocId = jsonDecode(res.body);
      print("this is " + res.body);

      await FirebaseFirestore.instance
          .collection("paymentIntent")
          .doc(getDocId["id"])
          .update({
        "hotelName": hotel.name,
        "roomName": room.title,
        "image": hotel.imagePath![0],
        "hotelAddress": hotel.location!.place_name,
        "status": "pay",
        "beginDate":
            Timestamp.fromDate(searchModel.searchState!.beginDate!).seconds,
        "endDate":
            Timestamp.fromDate(searchModel.searchState!.endDate!).seconds,
        "roomAmount": searchModel.searchState!.roomAmount,
      });

      // cập nhật lịch sử mua hàng của khách hàng
      await FirebaseFirestore.instance
          .collection("history")
          .doc(Timestamp.fromDate(DateTime.now()).seconds.toString())
          .set({"id": getDocId["id"], "uid": user.uid});
    } on Exception catch (error) {
      print(error);
    }

    return "Success";
  }

// ========================= REFUND IS HERE ======================= //
  Future<void> cancelBooking(
    String docId,
    String paymentIntentId,
  ) async {
    print(docId);
    print(paymentIntentId);
    print(
        "http://10.0.2.2:5001/booking-app-81eee/us-central1/createRefund?docId=$docId&paymentIntentId=$paymentIntentId");
    var res = await http.get(Uri.parse(
        "http://10.0.2.2:5001/booking-app-81eee/us-central1/createRefund?docId=$docId&paymentIntentId=$paymentIntentId"));
    print(res.body);
  }

  Future<String> hasPaymentAccout(String userId) async {
    // check xem tài khoản của người đó đã được xác thực và có thể thực hiện nhận thanh toán hay chưa
    try {
      var accountId =
          await FirebaseFirestore.instance.collection("Host").doc(userId).get();
      if (accountId.exists) {
        print(accountId.get("accountId"));
        var res = await http.get(Uri.parse(
            "http://10.0.2.2:5001/booking-app-81eee/us-central1/retrieveConnectedAccount?id=${accountId.get("accountId")}"));
        print(
            "===========http://10.0.2.2:5001/booking-app-81eee/us-central1/retrieveConnectedAccount?id=${accountId.get("accountId")}");
        if (res.statusCode == 500) return "false";
        if (res.statusCode == 400) return "Please check you internet";
        var check = jsonDecode(res.body) as Map<String, dynamic>;
        print(check["check"]);
        if (check["check"] == true) {
          return "true";
        } else
          return "false";
      } else {
        await FirebaseFirestore.instance
            .collection("Host")
            .doc(userId)
            .set({"accountId": ""});
        return "false";
      }
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  // HOST FIREBASE SERVICE =====================================================================
  // Update các trường trong thông tin của khác sạn
  Future<String> createPaymentAccount(String userId) async {
    try {
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/createPaymentAccount?userId=$userId"));
      print(res.body);
      var registerUrl = jsonDecode(res.body) as Map<String, dynamic>;
      print(registerUrl["accountLink"]["url"]);
      if (registerUrl.keys.contains("accountLink"))
        return registerUrl["accountLink"]["url"];
      return registerUrl.toString();
    } on HttpException catch (e) {
      return e.message;
    }
  }
}
