import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/host_hotel_screen/host_hotel_screen.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelNotifi/hotel_notifi.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';
import 'package:hotel_booking_app/widgets/time_ago/time_ago.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class HotelTab extends StatefulWidget {
  const HotelTab({
    required this.hotel,
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final void Function() callBack;
  final Hotel hotel;

  @override
  _HotelTabState createState() => _HotelTabState();
}

class _HotelTabState extends State<HotelTab> {
  Future<List<Notifi>> getHostNotifi(String hotelId) async {
    try {
      List<Notifi> noti = [];
      await FirebaseFirestore.instance
          .collection("hotelNotifi")
          .where("hotelId", isEqualTo: hotelId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async {
          var notifi = Notifi.fromJson(element.data());
          notifi.docId = element.id;
          noti.add(notifi);
        });
      });
      noti.sort((a, b) => (b.created! - a.created!));
      return noti;
    } on FirebaseException catch (error) {
      throw Exception(error.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SelectedHotel>(context, listen: false)
            .changeHotel(widget.hotel);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HostHotelScreen(
              callBack: widget.callBack,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 5,
          top: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(3, 3), // changes position of shadow
              ),
            ]),
        margin: EdgeInsets.only(
          top: 5,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.hotel.imagePath!.length != 0)
                ? Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCacheImage(
                        url: widget.hotel.imagePath![0],
                        height: 70,
                        width: 100,
                      ),
                    ),
                  )
                : Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/hotel_1.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "${widget.hotel.name}",
                    style: Constraint.Nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                FutureBuilder<List<Notifi>>(
                    future: getHostNotifi(widget.hotel.hotelID!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (widget.hotel.verify == null)
                                  ? Colors.green
                                  : (widget.hotel.verify == false)
                                      ? Colors.blue
                                      : Colors.orange,
                            ),
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            (widget.hotel.verify == null)
                                ? "Pending"
                                : (widget.hotel.verify == false)
                                    ? "Rejected"
                                    : "Approved",
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        bool checkNew = false;
                        for (var noti in snapshot.data!) {
                          if (noti.read == false) {
                            checkNew = true;
                            break;
                          }
                        }
                        return GestureDetector(
                          onTap: () async {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return NotificationScreen(notifi: snapshot.data!);
                            }));
                            for (var noti in snapshot.data!) {
                              await FirebaseFirestore.instance
                                  .collection("hotelNotifi")
                                  .doc(noti.docId)
                                  .update({"read": true});
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (widget.hotel.verify == null)
                                        ? Colors.green
                                        : (widget.hotel.verify == false)
                                            ? Colors.blue
                                            : Colors.orange,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  (widget.hotel.verify == null)
                                      ? "Pending"
                                      : (widget.hotel.verify == false)
                                          ? "Rejected"
                                          : "Approved",
                                  style: Constraint.Nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: (widget.hotel.verify == null)
                                        ? Colors.green
                                        : (widget.hotel.verify == false)
                                            ? Colors.blue
                                            : Colors.orange,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              if (checkNew)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    }),
              ],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.notifi,
  }) : super(key: key);

  final List<Notifi> notifi;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<Notifi> notifi;
  @override
  void initState() {
    // TODO: implement initState
    notifi = widget.notifi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification",
          style: Constraint.Nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: (notifi.length != 0)
          ? SizedBox.expand(
              child: ListView(
                children: List.generate(
                  widget.notifi.length,
                  (index) => Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      NotificationTab(notifi: notifi[index]),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 50,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  Text(
                    "No notification",
                    style: Constraint.Nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.5)),
                  )
                ],
              ),
            ),
    );
  }
}

class NotificationTab extends StatefulWidget {
  const NotificationTab({
    Key? key,
    required this.notifi,
  }) : super(key: key);
  final Notifi notifi;

  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  late Notifi notifi;
  @override
  void initState() {
    // TODO: implement initState
    notifi = widget.notifi;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            // height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: (notifi.status == "active")
                      ? Colors.orange.withOpacity(0.8)
                      : (notifi.status!.toLowerCase() == "pending")
                          ? Colors.greenAccent.withOpacity(0.7)
                          : Colors.blue.withOpacity(0.3),
                  offset: Offset(3, 3),
                  blurRadius: 0.2,
                  spreadRadius: 0.2,
                )
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (notifi.status!.toLowerCase() == "rejected")
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Your hotel has been rejected with the reason:\n",
                                style: Constraint.Nunito(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "   ${notifi.message}",
                                style: Constraint.Nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (notifi.status!.toLowerCase() == "active")
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Your hotel has been approved, from now our customer can book your hotel",
                                style: Constraint.Nunito(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: " ${notifi.message}",
                                style: Constraint.Nunito(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        TimeAgo.timeAgoSinceDate(notifi.created!),
                        style: Constraint.Nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.exit_to_app_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
