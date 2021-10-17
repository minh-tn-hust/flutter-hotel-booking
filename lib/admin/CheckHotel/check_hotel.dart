import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';

import 'widget/reivew_hotel.dart';

class CheckHotel extends StatefulWidget {
  const CheckHotel({Key? key}) : super(key: key);

  @override
  _CheckHotelState createState() => _CheckHotelState();
}

class _CheckHotelState extends State<CheckHotel> {
  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  Future<List<Hotel>> getUnverifyHotel() async {
    var list = await FirebaseFirestore.instance
        .collection("hotelWithInfo")
        .where("verity", isNull: true)
        .get();
    List<Hotel> unverityHotel = [];
    list.docs.forEach((element) {
      var hotel = Hotel.fromJson(element.data());
      hotel.hotelID = element.id;
      unverityHotel.add(hotel);
    });
    return unverityHotel;
  }

  Future<List<Hotel>> getRejectHotel() async {
    // veriti = false
    var list = await FirebaseFirestore.instance
        .collection("hotelWithInfo")
        .where("verity", isEqualTo: false)
        .get();
    List<Hotel> unverityHotel = [];
    list.docs.forEach((element) {
      var hotel = Hotel.fromJson(element.data());
      hotel.hotelID = element.id;
      unverityHotel.add(hotel);
    });
    return unverityHotel;
  }

  Future<List<Hotel>> getApproveHotel() async {
    // veriti = false
    var list = await FirebaseFirestore.instance
        .collection("hotelWithInfo")
        .where("verity", isEqualTo: true)
        .get();
    List<Hotel> unverityHotel = [];
    list.docs.forEach((element) {
      var hotel = Hotel.fromJson(element.data());
      hotel.hotelID = element.id;
      unverityHotel.add(hotel);
    });
    return unverityHotel;
  }

  Widget listHotel(
    Future<List<Hotel>>? future,
    bool canApprove,
    bool canReject,
  ) {
    TextStyle style18Bw = Constraint.Nunito(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    TextStyle style24Bw = Constraint.Nunito(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    return FutureBuilder<List<Hotel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Co loi xay ra roi"),
          );
        }
        if (snapshot.data!.length != 0) {
          return ListView(
            children: snapshot.data!.map(
              (e) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReviewHotel(
                              hotel: e,
                              callBack: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      title: Text(e.name!),
                      subtitle: Text(e.location!.text),
                      trailing: Container(
                        height: 100,
                        child: Column(
                          children: [
                            if (canApprove == true && canReject == true)
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
                            if (canApprove == true && canReject == false)
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: (e.hostID != null)
                                      ? Colors.blue
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  (e.hostID != null) ? "Rejected" : "Deleted",
                                  style: style18Bw,
                                ),
                              ),
                            if (canReject == true && canApprove == false)
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
                      thickness: 1,
                    ),
                  ],
                );
              },
            ).toList(),
          );
        } else {
          return Container(
            child: Center(
              child: Text(
                "No hotel found",
                style: style24Bw,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await pageController.animateToPage(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                    setState(() {
                      currentPage = 0;
                    });
                  },
                  child: Center(
                    child: Container(
                      color: (currentPage == 0)
                          ? Colors.greenAccent
                          : Colors.grey.shade500,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Pending Verify",
                          style: Constraint.Nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (currentPage == 0)
                                ? Colors.white
                                : Colors.white.withOpacity(0.65),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await pageController.animateToPage(1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                    setState(() {
                      currentPage = 1;
                    });
                  },
                  child: Center(
                    child: Container(
                      color: (currentPage == 1)
                          ? Colors.blue
                          : Colors.grey.shade500,
                      height: 50,
                      child: Center(
                          child: Text(
                        "Reject Hotel",
                        style: Constraint.Nunito(
                          color: (currentPage == 1)
                              ? Colors.white
                              : Colors.white.withOpacity(0.65),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await pageController.animateToPage(2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                    setState(() {
                      currentPage = 2;
                    });
                  },
                  child: Center(
                    child: Container(
                      color: (currentPage == 2)
                          ? Colors.orangeAccent
                          : Colors.grey.shade500,
                      height: 50,
                      child: Center(
                          child: Text(
                        "Approved Hotel",
                        style: Constraint.Nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (currentPage == 2)
                              ? Colors.white
                              : Colors.white.withOpacity(0.65),
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              controller: pageController,
              children: [
                listHotel(getUnverifyHotel(), true, true),
                listHotel(getRejectHotel(), true, false),
                listHotel(getApproveHotel(), false, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
