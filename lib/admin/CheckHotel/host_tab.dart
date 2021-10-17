import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/admin/CheckHotel/widget/reivew_hotel.dart';
import 'package:http/http.dart' as http;
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/HostInfo/host_info.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:http/http.dart';

class HostTab extends StatefulWidget {
  const HostTab({
    Key? key,
    required this.info,
    required this.callBack,
  }) : super(key: key);
  final Info info;
  final void Function() callBack;

  @override
  _HostTabState createState() => _HostTabState();
}

class _HostTabState extends State<HostTab> {
  late String firstName;
  late String lastName;
  late String email;
  TextEditingController descriptionCtrl = TextEditingController();
  int currentLength = 0;

  bool? baned;

  @override
  void initState() {
    // TODO: implement initState
    firstName = widget.info.customerInfo!.firstName!;
    lastName = widget.info.customerInfo!.lastName!;
    email = widget.info.email!;
    baned = widget.info.customerInfo!.baned;
    super.initState();
  }

  void showBanedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          height: 400,
          width: 400,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Feedback for user",
                style: Constraint.Nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  autofocus: true,
                  maxLength: 250,
                  controller: descriptionCtrl,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                  },
                  decoration: InputDecoration(
                    counterText: currentLength.toString(),
                    counterStyle: Constraint.Nunito(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Why this account has been banded?",
                  ),
                  maxLines: 15,
                  minLines: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: CustomButton(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.black.withOpacity(0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    );
                    Response res;
                    res = await http.get(Uri.parse(
                        "http://10.0.2.2:5001/booking-app-81eee/us-central1/banUser?uid=${widget.info.uid}&role=Host"));
                    var status = jsonDecode(res.body) as Map<String, dynamic>;
                    if (status["status"] == "Done") {
                      // tạo message cho host account
                      await FirebaseFirestore.instance
                          .collection("banMessage")
                          .doc(widget.info.uid)
                          .set({"message": descriptionCtrl.text});
                      for (var hotel in widget.info.hotels!) {
                        // update tình trạng hotel chuyển sang reject
                        await FirebaseFirestore.instance
                            .collection("hotelWithInfo")
                            .doc(hotel)
                            .update({"verity": false});
                        // update reject message cho hotel
                        await FirebaseFirestore
                            .instance // tạo notification cho host
                            .collection("hotelNotifi")
                            .add({
                          "hostId": widget.info.uid,
                          "hotelId": hotel,
                          "message":
                              "Host account has been baned, please contact to us for more infomation",
                          "status": "Rejected",
                          "read": false,
                          "created": Timestamp.fromDate(DateTime.now()).seconds,
                        });
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Done"),
                          content: Text(
                            "Update successful",
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            CustomButton(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                setState(() {
                                  if (baned == null) {
                                    baned = true;
                                  } else {
                                    baned = null;
                                  }
                                });
                              },
                              buttonTitle: "Confirm",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    } else
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Error"),
                          content: Text(
                            status["message"],
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            CustomButton(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              buttonTitle: "Confirm",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              height: 40,
                            ),
                          ],
                        ),
                      );
                  },
                  buttonTitle: "Ban",
                  textStyle: Constraint.Nunito(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showUnbanedDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.black.withOpacity(0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    Response res;
    res = await http.get(Uri.parse(
        "http://10.0.2.2:5001/booking-app-81eee/us-central1/unbanUser?uid=${widget.info.uid}&role=Host"));
    var status = jsonDecode(res.body) as Map<String, dynamic>;
    if (status["status"] == "Done") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Done"),
          content: Text(
            "Update successful",
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  if (baned == null) {
                    baned = true;
                  } else {
                    baned = null;
                  }
                });
              },
              buttonTitle: "Confirm",
              textStyle: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              height: 40,
            ),
          ],
        ),
      );
    }
  }

  void showHotelInfo(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: SizedBox(
              height: 500,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: HotelBottomSheet(
                    listHotel: widget.info.hotels!,
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showInfo(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: SizedBox(
              height: 450,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: InforBottomSheet(
                    customerInfo: widget.info.customerInfo!,
                    uid: widget.info.uid!,
                    callBack: (email, firstName, lastName) async {
                      setState(() {
                        this.email = email;
                        this.firstName = firstName;
                        this.lastName = lastName;
                      });
                      widget.callBack();
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      height: 133,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "UID:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      widget.info.uid!,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Email:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      email,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Name:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      firstName + " " + lastName,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Spacer(),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      showHotelInfo(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Hotels",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showInfo(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Infomation",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (baned == null) {
                        showBanedDialog();
                      } else {
                        showUnbanedDialog();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          (baned == null) ? "Baned" : "Unbaned",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (baned == null) ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InforBottomSheet extends StatefulWidget {
  const InforBottomSheet({
    Key? key,
    required this.customerInfo,
    required this.uid,
    required this.callBack,
  }) : super(key: key);
  final CustomerInfo customerInfo;
  final String uid;
  final void Function(String email, String firstNmae, String lastName) callBack;

  @override
  _InforBottomSheetState createState() => _InforBottomSheetState();
}

class _InforBottomSheetState extends State<InforBottomSheet> {
  bool? isEnable = false;
  final List<String> labels = [
    "Country",
    "Email",
    "First Name",
    "Last Name",
    "Mobile",
    "Post Code",
  ];
  late List<TextEditingController> controllers;
  @override
  void initState() {
    // TODO: implement initState
    controllers = [
      TextEditingController(text: widget.customerInfo.country),
      TextEditingController(text: widget.customerInfo.email),
      TextEditingController(text: widget.customerInfo.firstName),
      TextEditingController(text: widget.customerInfo.lastName),
      TextEditingController(text: widget.customerInfo.mobile),
      TextEditingController(text: widget.customerInfo.postcode),
    ];
    super.initState();
  }

  final int COUNTRY = 0;
  final int EMAIL = 1;
  final int FIRSTNAME = 2;
  final int LASTNAME = 3;
  final int MOBILE = 4;
  final int POSTCODE = 5;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Host Information",
            style: Constraint.Nunito(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            // scrollDirection: Axis.vertical,
            children: List.generate(
              5,
              (index) => Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      if (isEnable != null) {
                        setState(() {
                          isEnable = null;
                        });
                      }
                    },
                    enabled: (index == 0) ? false : true,
                    scrollPadding: EdgeInsets.only(left: 5, right: 5),
                    // validator: _validate,
                    controller: controllers[index + 1],
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      labelText: labels[index + 1],
                      labelStyle: Constraint.Nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
              try {
                await FirebaseFirestore.instance
                    .collection("userInfo")
                    .doc(widget.uid)
                    .update({
                  "lastName": controllers[LASTNAME].text,
                  // "country": controllers[COUNTRY].text,
                  "firstName": controllers[FIRSTNAME].text,
                  "postCode": controllers[POSTCODE].text,
                  "mobile": controllers[MOBILE].text,
                  "email": controllers[EMAIL].text,
                });
                Navigator.of(context).pop(); // pop the circle
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Done"),
                        content: Text("Data has been updated"),
                      );
                    });
                widget.callBack(controllers[EMAIL].text,
                    controllers[FIRSTNAME].text, controllers[LASTNAME].text);
              } on FirebaseException catch (e) {
                Navigator.of(context).pop(); // pop the circle
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("${e.message!}"),
                      );
                    });
              }
            },
            buttonTitle: "Update information",
            textStyle: Constraint.Nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            height: 60,
            isEnable: isEnable,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
//=============================HOTEL BOTTOM=======================================================

class HotelBottomSheet extends StatefulWidget {
  const HotelBottomSheet({
    Key? key,
    required this.listHotel,
  }) : super(key: key);
  final List<String> listHotel;
  @override
  _HotelBottomSheetState createState() => _HotelBottomSheetState();
}

class _HotelBottomSheetState extends State<HotelBottomSheet> {
  late List<TextEditingController> controllers;

  late Future<List<Hotel>> listHotel;

  TextStyle style18Bw = Constraint.Nunito(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  TextStyle style24Bw = Constraint.Nunito(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  Future<List<Hotel>> getHotelInfo(List<String> listHotelId) async {
    List<Hotel> res = [];
    try {
      for (var id in listHotelId) {
        var req = await FirebaseFirestore.instance
            .collection("hotelWithInfo")
            .doc(id)
            .get();
        var hotel = Hotel.fromJson(req.data() as Map<String, dynamic>);
        hotel.hotelID = id;
        print(hotel.toJson());
        res.add(hotel);
      }
      return res;
    } on FirebaseException catch (e) {
      throw Exception("${e.message!}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget hotelTab(Hotel hotel) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReviewHotel(
                  hotel: hotel,
                  callBack: () {
                    setState(() {});
                  },
                ),
              ),
            );
          },
          title: Text(hotel.name!),
          subtitle: Text(hotel.location!.text),
          trailing: Container(
            height: 100,
            child: Column(
              children: [
                if (hotel.verify == null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(3),
                    child: Text(
                      "Pending",
                      style: style18Bw,
                    ),
                  ),
                if (hotel.verify == false)
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Rejected",
                      style: style18Bw,
                    ),
                  ),
                if (hotel.verify == true)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(3),
                    child: Text(
                      "Approved",
                      style: style18Bw,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    listHotel = getHotelInfo(widget.listHotel);
    return Container(
      height: 500,
      // padding: EdgeInsets.only(
      //   left: 10,
      //   right: 10,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Text(
            "List Hotels",
            style: Constraint.Nunito(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder<List<Hotel>>(
            future: listHotel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text(snapshot.error!.toString()),
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => hotelTab(snapshot.data![index]),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
