import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/add_hotel_tab/add_hotel_tab.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/hotel_tab/hotel_tab.dart';
import 'package:hotel_booking_app/host/add_hotel/get_info.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelNotifi/hotel_notifi.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddHotel extends StatefulWidget {
  const AddHotel({Key? key}) : super(key: key);

  @override
  _AddHotelState createState() {
    return _AddHotelState();
  }
}

class _AddHotelState extends State<AddHotel> {
  Future<void> _launchInWebViewOrVC(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void createAccount(String uid) async {
    // hàm sử dụng để hiện thị ui với host lần đầu tiên tạo accout
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    var data = await FirebaseService.instance().createPaymentAccount(uid);
    Navigator.of(context).pop();
    if (data.contains("http")) {
      _launchInWebViewOrVC(data);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                CustomButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  buttonTitle: "Confirm",
                  textStyle: Constraint.Nunito(
                    fontSize: 14,
                  ),
                  height: 30,
                ),
              ],
              title: Text(
                "Error",
                style: Constraint.Nunito(),
              ),
              content: Text(
                data,
                style: Constraint.Nunito(),
              ),
            );
          });
    }
  }

  Future<List<Notifi>> getHostNotifi(String hotelId) async {
    try {
      List<Notifi> noti = [];
      var querySnapshot = await FirebaseFirestore.instance
          .collection("hotelNotifi")
          .where("hostId")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          noti.add(Notifi.fromJson(element.data()));
        });
      });
      return noti;
    } on FirebaseException catch (error) {
      throw Exception(error.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Add hotel setState");
    CollectionReference hotel =
        FirebaseFirestore.instance.collection("hotelWithInfo");
    User user = Provider.of<ApplicationState>(context).user!;
    FirebaseService fbService = new FirebaseService();
    // List<Hotel> listOwnHotel = hotel.where("hostID", isEqualTo: appState.uid).get().then((DocumentReference documentReference) => null);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Colors.white54,
          child: Stack(
            children: [
              Background(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Your hotel",
                          style: Constraint.Nunito(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Container(
                    height: 550,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 10,
                    ),
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: FutureBuilder<List<Hotel>>(
                      future: fbService.loadHotelWithUId(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return WaitingContainer();
                        }
                        if (snapshot.hasError) {
                          return ErrorContainer(
                            callBack: () {
                              setState(() {});
                            },
                          );
                        } else
                          return ListView.builder(
                              itemCount: snapshot.data!.length + 1,
                              itemBuilder: (context, index) {
                                if (index != snapshot.data!.length)
                                  return HotelTab(
                                    hotel: snapshot.data![index],
                                    callBack: () {
                                      setState(() {});
                                    },
                                  );
                                else
                                  return AddHotelTab(
                                    callBack: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      var uid = Provider.of<ApplicationState>(
                                              context,
                                              listen: false)
                                          .user!
                                          .uid;
                                      var status =
                                          await FirebaseService.instance()
                                              .hasPaymentAccout(uid);
                                      print("Addhote - status - $status");
                                      Navigator.of(context).pop();
                                      if (status == "true") {
                                        Provider.of<HotelProvider>(context,
                                                listen: false)
                                            .createNewHotel();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => GetInfo(
                                              callBack: () {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      } else if (status == "false")
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Required"),
                                                content: Text(
                                                  "Your need to payment account to add hotel or your payment account can't verify the infomation, please recreate/create",
                                                  style: Constraint.Nunito(),
                                                ),
                                                actions: [
                                                  CustomButton(
                                                    onTap: () async {
                                                      createAccount(uid);
                                                    },
                                                    buttonTitle: "Register",
                                                    textStyle:
                                                        Constraint.Nunito(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    height: 50,
                                                  ),
                                                ],
                                              );
                                            });
                                      else
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Warning",
                                                  style: Constraint.Nunito(),
                                                ),
                                                content: Text(
                                                  status,
                                                  style: Constraint.Nunito(),
                                                ),
                                              );
                                            });
                                    },
                                  );
                              });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(1),
          ],
          stops: [0.2, 0.8],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Image(
        image: AssetImage("assets/images/hotel.jpg"),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({Key? key, required this.callBack}) : super(key: key);
  final void Function() callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Something wrong in process, please try a gain"),
            FlatButton(
                onPressed: () {
                  callBack();
                },
                child: Text("Refresh")),
          ],
        ),
      ),
    );
  }
}

class WaitingContainer extends StatelessWidget {
  const WaitingContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
