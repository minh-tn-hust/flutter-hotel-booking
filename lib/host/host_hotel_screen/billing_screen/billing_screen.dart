import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/PaymentIntent/payment_intent.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'biling_tab.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late Hotel selectedHotel;
  Future<List<PaymentIntent>> getPaymentIntentFromHotelId(
      String hotelId) async {
    print("Call");
    try {
      var data = await FirebaseFirestore.instance
          .collection("paymentIntent")
          .where("hotelId", isEqualTo: hotelId)
          .get();
      List<PaymentIntent> list = data.docs
          .map((element) => PaymentIntent.fromJson(element.data()))
          .toList();
      list.sort((b, a) {
        if (a.beginDate! != b.beginDate!)
          return a.beginDate! - b.beginDate!;
        else
          return a.create! - b.create!;
      });
      return list;
    } on FirebaseException catch (e) {
      throw Exception(e.message!);
    }
  }

  late Future<List<PaymentIntent>> data;
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double money = 0;
  int bills = 0;
  @override
  void initState() {
    // TODO: implement initState
    selectedHotel =
        Provider.of<SelectedHotel>(context, listen: false).selectedHotel!;
    tryToFetchData();
    super.initState();
  }

  void tryToFetchData() async {
    String hotelID = selectedHotel.hotelID!;
    data = getPaymentIntentFromHotelId(hotelID);
  }

  void showDatePicker(
    BuildContext context,
    DateTime? begin,
    DateTime? end,
    List<PaymentIntent> list,
  ) {
    String ans;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        height: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              child: SfDateRangePicker(
                initialSelectedRange: PickerDateRange(begin, end),
                startRangeSelectionColor: Colors.orange,
                endRangeSelectionColor: Colors.orange,
                todayHighlightColor: Colors.orange,
                rangeSelectionColor: Color.fromRGBO(245, 161, 66, 0.2),
                selectionShape: DateRangePickerSelectionShape.rectangle,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (args) {
                  begin = args.value.startDate;
                  end = args.value.endDate;
                  print("Begin date = $begin");
                  print("End date = $end");
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: CustomButton(
                      buttonTitle: 'Confirm',
                      height: 50,
                      onTap: () {
                        print("Begin date = $begin");
                        print("End date = $end");
                        setState(() {
                          beginDate = begin!;
                          if (end != null)
                            endDate = end!;
                          else
                            endDate = begin!;
                          loadData(list);
                        });
                        Navigator.of(context).pop();
                      },
                      textStyle: Constraint.Nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget error() {
    return Container(
      height: 500,
      child: Center(
        child: Column(
          children: [
            Text("Has something wrong in process, please try again"),
            CustomButton(
              onTap: () {
                setState(() {
                  tryToFetchData();
                });
              },
              buttonTitle: "Try again",
              textStyle: Constraint.Nunito(),
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  int dateCompare(DateTime a, DateTime b) {
    if (a.year < b.year) return 1;
    if (a.year > b.year) return -1;
    if (a.month < b.month) return 1;
    if (a.month > b.month) return -1;
    if (a.day < b.day) return 1;
    if (a.day > b.day) return -1;
    return 0;
  }

  loadData(List<PaymentIntent> list) {
    money = 0;
    bills = 0;
    List<PaymentIntent> paymentIntents = [];
    if (dateCompare(beginDate, endDate) == 0) {
      for (int i = 0; i < list.length; i++) {
        print(list[i]);
        print("loadData - begin Date = $beginDate");
        print("loadData - end Date = $endDate");
        var check = DateTime.fromMillisecondsSinceEpoch(list[i].create! * 1000);
        if (dateCompare(beginDate, check) == 0) {
          paymentIntents.add(list[i]);
          if (list[i].status! != "cancel" && list[i].status! != "refund") {
            money += list[i].amount! / 100;
            bills++;
          }
        }
      }
      if (paymentIntents.length == 0)
        return Container(
            height: 400,
            child: Center(
              child: Text(
                "No payment in this time",
                style: Constraint.Nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
      return Column(
        children: paymentIntents
            .map((e) => Column(
                  children: [
                    Divider(),
                    BillingTab(payment: e),
                  ],
                ))
            .toList(),
      );
    } else {
      for (int i = 0; i < list.length; i++) {
        print(list[i]);
        print("begin Date = $beginDate");
        var check = DateTime.fromMillisecondsSinceEpoch(list[i].create! * 1000);
        if (dateCompare(beginDate, check) >= 0 &&
            dateCompare(endDate, check) <= 0) {
          paymentIntents.add(list[i]);
          if (list[i].status! != "cancel" && list[i].status! != "refund") {
            print(list[i].status);
            money += list[i].amount! / 100;
            bills++;
          }
        }
      }
      if (paymentIntents.length == 0)
        return Container(
            height: 400,
            child: Center(
              child: Text(
                "No payment in this time",
                style: Constraint.Nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
      return Column(
        children: paymentIntents
            .map((e) => Column(
                  children: [
                    Divider(),
                    BillingTab(payment: e),
                  ],
                ))
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build called");
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            BackButtonAndTitle(
              title: "Hotel Billing",
              needBackgournd: true,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFf4610b), Color(0xFFffb61a)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedHotel.name!,
                        style: Constraint.Nunito(
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Money from this hotel",
                              style: Constraint.Nunito(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            FutureBuilder<List<PaymentIntent>>(
                                future: data,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasError == true) {
                                    return Text(
                                      "**\$",
                                      style: Constraint.Nunito(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    loadData(snapshot.data!);
                                    return Text(
                                      "${money.toStringAsFixed(2)}\$",
                                      style: Constraint.Nunito(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bills from this hotel",
                              style: Constraint.Nunito(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                FutureBuilder<List<PaymentIntent>>(
                                    future: data,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          snapshot.hasError == true) {
                                        return Text(
                                          "**",
                                          style: Constraint.Nunito(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        );
                                      } else {
                                        loadData(snapshot.data!);
                                        return Text(
                                          "$bills",
                                          style: Constraint.Nunito(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                    }),
                                Icon(
                                  Icons.payment_sharp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              (dateCompare(beginDate, endDate) == 0)
                                  ? "${DateFormat.yMMMd().format(beginDate)}"
                                  : "${DateFormat.yMMMd().format(beginDate)} - ${DateFormat.yMMMd().format(endDate)}",
                              style: Constraint.Nunito(
                                fontSize: (dateCompare(beginDate, endDate) == 0)
                                    ? 18
                                    : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: FutureBuilder<List<PaymentIntent>>(
                            future: data,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.hasError) {
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return CustomButton(
                                onTap: () {
                                  showDatePicker(context, beginDate, endDate,
                                      snapshot.data!);
                                },
                                buttonTitle: "Filter",
                                textStyle: Constraint.Nunito(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                height: 50,
                              );
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<PaymentIntent>>(
                    future: data,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return loadData(snapshot.data!);
                      }
                      if (snapshot.hasError) {
                        return error();
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
