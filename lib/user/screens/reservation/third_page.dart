import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({
    Key? key,
    required this.creditCard,
    required this.customerInfo,
  }) : super(key: key);
  final CreditCard creditCard;
  final CustomerInfo customerInfo;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  DateTime beginDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int? roomAmount;
  int? maxRoom;
  int? guest;
  Hotel? hotel;
  Room? room;
  Object? get cardInfo => null;
  void initState() {
    super.initState();
    var info = Provider.of<SearchModel>(context, listen: false);
    beginDate = info.searchState!.beginDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    endDate = info.searchState!.endDate ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    guest = info.searchState!.guests ?? 1;
    roomAmount = info.searchState!.roomAmount ?? 1;
    hotel = info.pickHotel!;
    room = info.pickRoom!;
    maxRoom = info.roomAvailable!;
  }

  Widget showPickDateAndRoom() {
    return Row(
      children: [
        Expanded(
          // nút để khách có thể chọn ngày
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            height: 60,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: FlatButton(
                onPressed: () {
                  showPickDate();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Date",
                      textAlign: TextAlign.center,
                      style: Constraint.Nunito(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${DateFormat.MMMd().format(beginDate)} - ${DateFormat.MMMd().format(endDate)}",
                      style: Constraint.Nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Divider(),
        Expanded(
          //nút để khách có thể chọn phòng
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            height: 60,
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Number of room",
                  textAlign: TextAlign.center,
                  style: Constraint.Nunito(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          roomAmount = max(0, roomAmount! - 1);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.remove,
                          size: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "$roomAmount Rooms",
                      style: Constraint.Nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          roomAmount = min(roomAmount! + 1, maxRoom!);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.add,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget showNameAndType() {
    return Column(
      children: [
        TextFormField(
          style: Constraint.Nunito(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: "Hotel Name",
            labelStyle: Constraint.Nunito(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          controller: TextEditingController(text: "${hotel!.name}"),
          enabled: false,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          style: Constraint.Nunito(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: "Room Type",
            labelStyle: Constraint.Nunito(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          controller: TextEditingController(text: "${room!.title}"),
          enabled: false,
        ),
      ],
    );
  }

  // Show datepicker
  void showPickDate() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        height: 360,
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
                initialSelectedRange: PickerDateRange(
                  beginDate,
                  endDate,
                ),
                startRangeSelectionColor: Colors.orange,
                endRangeSelectionColor: Colors.orange,
                todayHighlightColor: Colors.orange,
                rangeSelectionColor: Color.fromRGBO(245, 161, 66, 0.2),
                selectionShape: DateRangePickerSelectionShape.rectangle,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (args) {
                  setState(() {
                    print("Print date picker");
                    print(args.value.startDate);
                    print(args.value.endDate);
                    if (args.value.startDate != null)
                      beginDate = args.value.startDate;
                    if (args.value.endDate != null)
                      endDate = args.value.endDate;
                  });
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
                        if (beginDate.compareTo(DateTime.now()) < 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text("Warning"),
                              content: Text(
                                "Your picked time was in the past, please pick again",
                                style: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              actions: [
                                CustomButton(
                                  onTap: () {
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
                        } else {
                          Navigator.of(context).pop();
                        }
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

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ApplicationState>(context).user!;
    var searchMode = Provider.of<SearchModel>(context);
    double amount =
        endDate.difference(beginDate).inDays * (room!.price!) * roomAmount!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButtonAndTitle(title: "Reservation"),
              //show thứ tự hoàn thành của payment
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "2",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              // show hình ảnh khách sạn mà khách đã chọn
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 400,
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.6)
                        ],
                        stops: [0.2, 0.9],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CustomCacheImage(
                          url: "${hotel!.imagePath![0]}",
                          height: 200,
                          width: 330),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 0,
                    child: Text(
                      hotel!.name!,
                      style: Constraint.Nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      // tên khách sạn đã chọn
                      TextFormField(
                        autofocus: true,
                        style: Constraint.Nunito(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.orangeAccent, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Guests",
                          labelStyle: Constraint.Nunito(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: TextEditingController(text: "1"),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showPickDateAndRoom(),
                      SizedBox(
                        height: 15,
                      ),
                      showNameAndType(),
                      SizedBox(
                        height: 15,
                      ),
                      Spacer(),
                      Divider(
                        height: 30,
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      // nút thanh toán + thông báo giá cho khách
                      Row(
                        children: [
                          Text(
                            "${amount.toStringAsFixed(2)}\$",
                            style: Constraint.Nunito(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              child: CustomButton(
                                  onTap: () {
                                    if (amount != 0) {
                                      Provider.of<SearchModel>(context,
                                              listen: false)
                                          .updateGuests(guest!);
                                      Provider.of<SearchModel>(context,
                                              listen: false)
                                          .updateTime(beginDate, endDate);
                                      Provider.of<SearchModel>(context,
                                              listen: false)
                                          .updateTime(beginDate, endDate);
                                      Provider.of<SearchModel>(context,
                                              listen: false)
                                          .updateRoomAmount(roomAmount!);
                                      String? response;
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        useSafeArea: false,
                                        builder: (context) {
                                          return FutureBuilder<String>(
                                              future: FirebaseService.instance()
                                                  .firstPay(
                                                int.parse((amount * 100)
                                                    .toStringAsFixed(0)),
                                                widget.creditCard,
                                                widget.customerInfo,
                                                user,
                                                searchMode,
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return WillPopScope(
                                                    onWillPop: () {
                                                      return Future.value(
                                                          false);
                                                    },
                                                    child: AlertDialog(
                                                      content: Container(
                                                        height: 100,
                                                        width: 100,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      ),
                                                      title: Text(
                                                          "Process take a minutes"),
                                                      titleTextStyle:
                                                          Constraint.Nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  if (snapshot.data ==
                                                      "Success") {
                                                    return WillPopScope(
                                                      onWillPop: () {
                                                        return Future.value(
                                                            false);
                                                      },
                                                      child: AlertDialog(
                                                        contentTextStyle:
                                                            Constraint.Nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        content: Text(
                                                            "You are booked your hotel"),
                                                        title: Text("Success"),
                                                        titleTextStyle:
                                                            Constraint.Nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 5,
                                                            ),
                                                            child: CustomButton(
                                                              onTap: () {
                                                                Provider.of<ApplicationState>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .initCustomer(
                                                                        user.uid);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              buttonTitle:
                                                                  "Confirm",
                                                              textStyle:
                                                                  Constraint
                                                                      .Nunito(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: 50,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  return WillPopScope(
                                                    onWillPop: () {
                                                      return Future.value(
                                                          false);
                                                    },
                                                    child: AlertDialog(
                                                      contentTextStyle:
                                                          Constraint.Nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      content: Text(
                                                          "Something wrong in our process, ${snapshot.data}"),
                                                      title:
                                                          Text("Payment fail"),
                                                      titleTextStyle:
                                                          Constraint.Nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      actions: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 5,
                                                          ),
                                                          child: CustomButton(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {});
                                                            },
                                                            buttonTitle:
                                                                "Confirm",
                                                            textStyle:
                                                                Constraint
                                                                    .Nunito(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            height: 50,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              });
                                        },
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              titleTextStyle: Constraint.Nunito(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              contentTextStyle:
                                                  Constraint.Nunito(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                              title: Text("Warning"),
                                              content: Text(
                                                "You cant book hotel with no day",
                                              ),
                                              actions: [
                                                CustomButton(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    buttonTitle: "Confirm",
                                                    textStyle:
                                                        Constraint.Nunito(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    height: 50)
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  buttonTitle: "Confirm",
                                  textStyle: Constraint.Nunito(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  height: 60),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
