import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/hotel_detail.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/detail.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../../constraint.dart';

class HostHotelInfo extends StatefulWidget {
  const HostHotelInfo({
    Key? key,
    required this.callBack,
  }) : super(key: key);
  final void Function() callBack;

  @override
  _HostHotelInfoState createState() => _HostHotelInfoState();
}

class _HostHotelInfoState extends State<HostHotelInfo> {
  late Hotel hotel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    hotel = Provider.of<SelectedHotel>(context).selectedHotel!;
    print("Host_Frame - HotelTab - HostHotelRoom - HotelInfo - rebuild");
    List<dynamic> title = [];
    List<dynamic> content = [];
    hotel.toJson().forEach((key, value) {
      if (key != "payID" &&
          key != "hostID" &&
          key != "verity" &&
          key != "type" &&
          key != "destination") {
        title.add(key);
        content.add(value);
      }
    });
    print(title);
    print("host_hotel_info - hotel - ${hotel.toJson()}");
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(title.length + 1, (index) {
              if (index == title.length) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: CustomButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    CustomButton(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FutureBuilder(
                                                  future: Provider.of<
                                                              SelectedHotel>(
                                                          context,
                                                          listen: false)
                                                      .deleteHotel(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.data ==
                                                        "Done") {
                                                      return AlertDialog(
                                                        actions: [
                                                          CustomButton(
                                                            onTap: () {
                                                              widget.callBack();
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
                                                              fontSize: 14,
                                                            ),
                                                            height: 30,
                                                          ),
                                                        ],
                                                        title: Text(
                                                          "Done",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                        content: Text(
                                                          "Your hotel has been deleted",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                      );
                                                    } else {
                                                      return AlertDialog(
                                                        actions: [
                                                          CustomButton(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            buttonTitle:
                                                                "Confirm",
                                                            textStyle:
                                                                Constraint
                                                                    .Nunito(
                                                              fontSize: 14,
                                                            ),
                                                            height: 30,
                                                          ),
                                                        ],
                                                        title: Text(
                                                          "Error",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                        content: Text(
                                                          "${snapshot.data}",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                      );
                                                    }
                                                  });
                                            });
                                      },
                                      buttonTitle: "Confirm",
                                      textStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      buttonTitle: "Cancel",
                                      textStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      height: 30,
                                    ),
                                  ],
                                  title: Text(
                                    "Warning",
                                    style: Constraint.Nunito(),
                                  ),
                                  content: Text(
                                    "After you delete this, you can restore, are you sure?",
                                    style: Constraint.Nunito(),
                                  ),
                                );
                              });
                        },
                        buttonTitle:
                            "Delete this ${(hotel.type == 1) ? "hotel" : "homestay"}",
                        textStyle: Constraint.Nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  HotelDetail(
                    title: title[index],
                    content: content[index],
                    docId: hotel.hotelID!,
                    callBack: () {
                      widget.callBack();
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1.5,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
