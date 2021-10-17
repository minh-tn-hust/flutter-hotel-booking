import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/editable_tile.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/header_information.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/password_editor.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/present_cards.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/profile_screen_option.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.customerInfo,
    this.isHost,
  }) : super(key: key);
  final CustomerInfo? customerInfo;
  final bool? isHost;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PageController? pageController;
  double viewportFraction = 0.93;
  double pageOffset = 0;
  CustomerInfo? customerInfo;
  bool showProfile = false;
  bool showChangePassword = false;
  double infoHeight = 0;
  double? passwordHeight = 0;
  // info
  TextEditingController? lastNameTextCtrl;
  TextEditingController? firstNameTextCtrl;
  TextEditingController? phoneNumberTextCtrl;
  TextEditingController? postCodeTextCtrl;
  TextEditingController? emailTextCtrl;
  // password
  TextEditingController oldPasswordTextCtrl = TextEditingController();
  TextEditingController newPasswordTextCtrl = TextEditingController();
  TextEditingController confirmPasswordTextCtrl = TextEditingController();

  @override
  void initState() {
    customerInfo =
        Provider.of<ApplicationState>(context, listen: false).customerInfo;
    CustomerInfo? info = customerInfo;
    if (info != null) {
      lastNameTextCtrl = TextEditingController(
        text: info.lastName,
      );
      emailTextCtrl = TextEditingController(text: info.email);
      firstNameTextCtrl = TextEditingController(text: info.firstName);
      postCodeTextCtrl = TextEditingController(text: info.postcode);
      phoneNumberTextCtrl = TextEditingController(text: info.mobile);
    }
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      initialPage: 0,
      viewportFraction: viewportFraction,
    )..addListener(() {
        setState(() {
          pageOffset = pageController!.page!;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    customerInfo = Provider.of<ApplicationState>(context).customerInfo;
    print(customerInfo);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // information top bar
                SizedBox(
                  height: 90,
                ),
                // present card
                if (customerInfo != null && widget.isHost == null)
                  PresentCards(
                    pageController: pageController,
                    viewportFraction: viewportFraction,
                    pageOffset: pageOffset,
                    customerInfo: customerInfo,
                    callBack: () {
                      setState(() {});
                    },
                  ),
                // Info của người dùng
                if (customerInfo != null)
                  ProfileScreenOption(
                    icon: Icon(Icons.verified_user_rounded),
                    onTap: () {
                      setState(() {
                        showProfile = !showProfile;
                        if (showProfile)
                          infoHeight = 320;
                        else
                          infoHeight = 0;
                      });
                      print("This is Profile");
                      print("$infoHeight");
                    },
                    title: 'Your profile',
                  ),
                if (showProfile)
                  SizedBox(
                    height: 15,
                  ),
                // phần hiển thị thông tin
                Padding(
                  // nếu như nhấp vào Profile, infoHeight (dòng 115) sẽ thay đổi để có thể hiện thị thông tin lên
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                    decoration: BoxDecoration(
                      color: Color(0xffd9e5f6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                        (showProfile) // check xem người dùng đã nhấp vào Profile hay chưa bằng biến showProfile
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  EditableTile(
                                    callBack: () {
                                      setState(() {
                                        customerInfo =
                                            Provider.of<ApplicationState>(
                                                    context,
                                                    listen: false)
                                                .customerInfo;
                                      });
                                    },
                                    content: (customerInfo!.lastName),
                                    title: "First Name",
                                    textController: firstNameTextCtrl!,
                                  ),
                                  EditableTile(
                                    callBack: () {
                                      setState(() {});
                                    },
                                    content: customerInfo!.lastName,
                                    title: "Last Name",
                                    textController: lastNameTextCtrl!,
                                  ),
                                  EditableTile(
                                    callBack: () {
                                      setState(() {});
                                    },
                                    content: customerInfo!.postcode,
                                    title: "Post Code",
                                    textController: postCodeTextCtrl!,
                                  ),
                                  EditableTile(
                                    callBack: () {
                                      setState(() {});
                                    },
                                    content: customerInfo!.mobile,
                                    title: "Phone number",
                                    textController: phoneNumberTextCtrl!,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )
                            : Container(),
                  ),
                ),
                if (customerInfo != null)
                  SizedBox(
                    height: 15,
                  ),
                // pass word
                if (customerInfo != null)
                  ProfileScreenOption(
                    title: "Change password",
                    onTap: () {
                      setState(() {
                        showChangePassword = !showChangePassword;
                        if (showChangePassword)
                          passwordHeight = 350;
                        else
                          passwordHeight = 0;
                      });
                      print("This is Profile");
                      print("$passwordHeight");
                    },
                    icon: Icon(Icons.password),
                  ),
                if (showChangePassword)
                  SizedBox(
                    height: 15,
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceOut,
                    decoration: BoxDecoration(
                      color: Color(0xffd9e5f6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: (showChangePassword)
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    PasswordEditor(
                                      controller: oldPasswordTextCtrl,
                                      title: "Old password",
                                      validate: (value) {
                                        if (value == "")
                                          return "Your old password must be none empty";
                                      },
                                    ),
                                    PasswordEditor(
                                      controller: newPasswordTextCtrl,
                                      title: "New password",
                                      validate: (value) {
                                        if (value == "")
                                          return "Your new password must be none empty";
                                      },
                                    ),
                                    PasswordEditor(
                                      controller: confirmPasswordTextCtrl,
                                      title: "Confirm password",
                                      validate: (value) {
                                        if (value == "")
                                          return "Your confirm-password must be none empty";
                                        if (value != newPasswordTextCtrl.text) {
                                          return "Password not match";
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12),
                                child: CustomButton(
                                    onTap: () {
                                      if (_formKey.currentState!.validate())
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FutureBuilder<String>(
                                                  future: Provider.of<
                                                              ApplicationState>(
                                                          context,
                                                          listen: false)
                                                      .changePassword(
                                                          oldPasswordTextCtrl
                                                              .text,
                                                          newPasswordTextCtrl
                                                              .text,
                                                          confirmPasswordTextCtrl
                                                              .text),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return WillPopScope(
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          onWillPop: () =>
                                                              Future.value(
                                                                  false));
                                                    }
                                                    if (snapshot.data !=
                                                        "Done") {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Change password",
                                                            style: Constraint
                                                                .Nunito()),
                                                        content: Text(
                                                            snapshot.data!),
                                                        actions: [
                                                          CustomButton(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              buttonTitle:
                                                                  "Confirm",
                                                              textStyle: Constraint.Nunito(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                              height: 50)
                                                        ],
                                                      );
                                                    } else
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Warning",
                                                          style:
                                                              Constraint.Nunito(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "Your password has been changed",
                                                          style:
                                                              Constraint.Nunito(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        actions: [
                                                          CustomButton(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              buttonTitle:
                                                                  "Confirm",
                                                              textStyle: Constraint.Nunito(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                              height: 50)
                                                        ],
                                                      );
                                                  });
                                            });
                                    },
                                    buttonTitle: "Submit",
                                    textStyle: Constraint.Nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    height: 50),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileScreenOption(
                  title: (customerInfo != null) ? "Log out" : "Log in",
                  onTap: () {
                    if (customerInfo != null) {
                      Provider.of<ApplicationState>(context, listen: false)
                          .signOut();
                      setState(() {
                        customerInfo = null;
                        showProfile = false;
                        showChangePassword = false;
                      });
                    } else {
                      // TODO: login in this place
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => Consumer<ApplicationState>(
                      //     builder: (context, state, _) => LoginScreen(
                      //       state: state,
                      //     ),
                      //   ),
                      // ));
                      Provider.of<ApplicationState>(context, listen: false)
                          .login();
                    }
                  },
                  icon: (customerInfo != null)
                      ? Icon(Icons.logout)
                      : Icon(Icons.login),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
        Positioned(child: HeaderInformation(customerInfo: customerInfo)),
      ],
    );
  }
}
