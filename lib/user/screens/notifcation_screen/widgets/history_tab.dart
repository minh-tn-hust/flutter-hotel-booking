import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/hotel_detail_screen.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/time_ago/time_ago.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    required this.color,
    required this.docId,
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final Color color;
  final String docId;
  final void Function() callBack;
  void showBookingInfo(
      BuildContext context, Map<String, dynamic> historyInfo) async {
    var x = await showModalBottomSheet<String>(
        routeSettings: RouteSettings(arguments: "hello"),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return BookingInfo(
            callBack: () {
              callBack();
            },
            info: historyInfo,
          );
        }).whenComplete(() => callBack());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: FirebaseService.instance().getHistoreyInfo(docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text("This History is delete"),
            );
          }
          Map<String, dynamic> historyInfo = snapshot.data!;
          historyInfo.addAll({"docId": docId});
          return GestureDetector(
            onTap: () {
              showBookingInfo(context, historyInfo);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: (historyInfo["status"] == "checkout")
                        ? Colors.green.withOpacity(0.8)
                        : (historyInfo["status"] != "cancel")
                            ? color.withOpacity(0.4)
                            : Colors.black.withOpacity(0.3),
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
                        Text(
                          "Your stay at ${historyInfo["hotelName"]} is booked in ${DateTime.fromMillisecondsSinceEpoch(historyInfo["endDate"] * 1000).difference(DateTime.fromMillisecondsSinceEpoch(historyInfo["beginDate"] * 1000)).inDays} days",
                          style: Constraint.Nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          TimeAgo.timeAgoSinceDate(historyInfo["create"]),
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
          );
        });
  }
}

class BookingInfo extends StatefulWidget {
  const BookingInfo({
    Key? key,
    required this.info,
    required this.callBack,
  }) : super(key: key);
  final void Function() callBack;
  final Map<String, dynamic> info;

  @override
  _BookingInfoState createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {
  late String status;
  late Hotel hotel;
  @override
  void initState() {
    // TODO: implement initState
    status = widget.info["status"];
    super.initState();
  }

// thực hiện xử lý để trả tiền cho khách hàng
  void refundProcess(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: FirebaseService.instance().cancelBooking(
              widget.info["docId"],
              widget.info["paymentIntentId"],
            ), // thời gian người đó ở phòng
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  title: Text("Waiting"),
                  content: Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return AlertDialog(
                actions: [
                  CustomButton(
                      onTap: () {
                        widget.callBack();
                        setState(() {
                          status = "cancel";
                        });
                        Navigator.of(context).pop();
                      },
                      buttonTitle: "Confirm",
                      textStyle: Constraint.Nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      height: 50)
                ],
                title: Text("Success"),
                content: Container(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Text(
                      "Canceling successful",
                      style: Constraint.Nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var create = widget.info["create"];
    var different =
        (DateTime.now().millisecondsSinceEpoch / 1000 - create) / 60 / 60 / 24;
    print("HistoryTab - BookingInfo - build - different = $different");
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      height: 550,
      child: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: CustomCacheImage(
                    url: widget.info["image"], height: 200, width: 330),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade600.withOpacity(0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        var hotelId = widget.info["hotelId"];
                        var json = await FirebaseFirestore.instance
                            .collection("hotelWithInfo")
                            .doc(hotelId)
                            .get();
                        var hotel = Hotel.fromJson(json.data()!);
                        hotel.hotelID = hotelId;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                HotelDetailScreen(hotel: hotel),
                          ),
                        );
                      } on FirebaseException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Error",
                                  style: Constraint.Nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                content: Text(
                                  "${e.message}",
                                  style: Constraint.Nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: Text(
                      widget.info["hotelName"],
                      style: Constraint.Nunito(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  ),
                  Text(
                    widget.info["hotelAddress"],
                    style: Constraint.Nunito(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    widget.info["roomName"] + " room",
                    style: Constraint.Nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: Constraint.Nunito(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'from '),
                        new TextSpan(
                          text: DateFormat.MMMEd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.info["beginDate"] * 1000)),
                          style: Constraint.Nunito(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new TextSpan(
                          text: ' to ',
                        ),
                        new TextSpan(
                          text: DateFormat.MMMEd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.info["endDate"] * 1000)),
                          style: Constraint.Nunito(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      (status != "cancel" &&
                              status != "checkout" &&
                              status != "checking")
                          ? CustomButton(
                              onTap: () {
                                if (different >= 4) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Warning",
                                            style: Constraint.Nunito(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            "We will get 30% of the payment for the booking fee, agree to refund?",
                                            style: Constraint.Nunito(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          actions: [
                                            CustomButton(
                                              buttonTitle: 'YES',
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                refundProcess(context);
                                              },
                                              textStyle: Constraint.Nunito(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Colors.white),
                                              height: 50,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CustomButton(
                                              height: 50,
                                              textStyle: Constraint.Nunito(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Colors.white),
                                              buttonTitle: 'NO',
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else
                                  refundProcess(context);
                              },
                              buttonTitle: "Cancel",
                              textStyle: Constraint.Nunito(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              height: 50,
                            )
                          : Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: (status == "cancel")
                                    ? Colors.grey
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Center(
                                  child: Text(
                                (status == "cancel")
                                    ? "Canceled"
                                    : (status == "checking")
                                        ? "On room"
                                        : "Checkout",
                                style: Constraint.Nunito(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                      Spacer(),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: (status != "cancel")
                              ? Colors.greenAccent
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              height: 50,
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF8A170),
                                    Color(0xFFFFCD61)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FittedBox(
                                child: Text(
                                  "\$${(double.parse(widget.info["amount"].toString()) / 100)}",
                                  style: Constraint.Nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Center(
                                    child: Text(
                              (status != "cancel") ? "Booked" : "Canceled",
                              style: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
