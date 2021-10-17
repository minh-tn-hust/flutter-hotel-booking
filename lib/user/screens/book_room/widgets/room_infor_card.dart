import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/book_room/widgets/feature_row.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_preview.dart';
import 'package:hotel_booking_app/user/screens/reservation/first_page.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/third_page_2.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/login_form.dart';
import 'package:provider/provider.dart';

class RoomInforCard extends StatefulWidget {
  const RoomInforCard({
    Key? key,
    required this.room,
  }) : super(key: key);
  final Room room;

  @override
  _RoomInforCardState createState() => _RoomInforCardState();
}

class _RoomInforCardState extends State<RoomInforCard> {
  CustomerInfo? customerInfo;
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            height:
                min(600.0, (widget.room.amenities!.length + 2) * 1.0 / 3 * 120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: (widget.room.amenities!.length != 0)
                ? ListView(
                    children: [
                      Column(
                        children: [
                          Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: List.generate(
                              widget.room.amenities!.length,
                              (index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.orange, width: 1.4),
                                ),
                                height: 90,
                                width: 100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        IconLib.iconRoomLib[
                                            widget.room.amenities![index]]!,
                                        color: Colors.black,
                                        height: 25,
                                        width: 25,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.room.amenities![index]}",
                                        textAlign: TextAlign.center,
                                        style: Constraint.Nunito(
                                          fontSize: 15,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print("ROOMCARDSTATE - REBUILD");
    customerInfo = Provider.of<ApplicationState>(context).customerInfo;
    var searchModel = Provider.of<SearchModel>(context);
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context);
      },
      //details card
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color(0xFFF5F5F5),
          borderOnForeground: true,
          elevation: 1,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: ImagePreview(
                    height: 335,
                    imagePaths: widget.room.imagePath!,
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 18,
                ),
                child: Column(
                  children: [
                    Row(
                      //Title
                      children: [
                        Container(
                          width: 307,
                          child: Text(
                            widget.room.title!,
                            style: Constraint.Nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Icon(
                          Icons.info,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
//======================================================================================
                    (widget.room.amenities!.length != 0)
                        ? Column(
                            // Features
                            children: List.generate(
                                widget.room.amenities!.length, (index) {
                              return Column(
                                children: [
                                  FeatureRow(
                                    content: widget.room.amenities![index],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            }),
                          )
                        : SizedBox(),
//==============================================================================================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.more,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "More ${widget.room.amenities!.length} extensions",
                          style: Constraint.Nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$ ${widget.room.price}",
                                style: Constraint.Nunito(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "1 Nights",
                                style: Constraint.Nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 185,
                          padding: EdgeInsets.only(bottom: 18),
                          child: FutureBuilder<int>(
                              future: FirebaseService.instance().checkColusion(
                                searchModel.pickHotel!.hotelID!,
                                widget.room.id!,
                                searchModel.searchState!.beginDate,
                                searchModel.searchState!.endDate,
                                widget.room.recentAvailable!,
                              ),
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Checking",
                                        style: Constraint.Nunito(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.data! < -1) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Out of room",
                                        style: Constraint.Nunito(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return CustomButton(
                                    onTap: () {
                                      {
                                        if (snapshot.data == -1) {
                                          // nếu như user chưa chọn ngày thì bắt user chọn ngày
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  actions: [
                                                    CustomButton(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        buttonTitle: "Confirm",
                                                        textStyle:
                                                            Constraint.Nunito(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                        height: 50)
                                                  ],
                                                  title: Text(
                                                    "Error",
                                                    style: Constraint.Nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "You don't choose the time you want, back to homescreeen and pick it",
                                                    style: Constraint.Nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else if (snapshot.data! >= 0) {
                                          // nếu như đủ phòng
                                          if (customerInfo != null) {
                                            print(
                                                "True - Snapshot Data: ${snapshot.data}");
                                            Provider.of<SearchModel>(context,
                                                    listen: false)
                                                .updateRoomType(widget.room);
                                            Provider.of<SearchModel>(context,
                                                    listen: false)
                                                .updateRoomAvailable(
                                                    snapshot.data!);
                                            if (customerInfo!.customerID !=
                                                "new") {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FinalPage(
                                                            creditCard: null,
                                                          )));
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FirstPage()));
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Warning",
                                                    style: Constraint.Nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "To book this room, you need to login",
                                                    style: Constraint.Nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  actions: [
                                                    CustomButton(
                                                        onTap: () {
                                                          Provider.of<ApplicationState>(
                                                                  context,
                                                                  listen: false)
                                                              .login();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                              return Consumer<
                                                                  ApplicationState>(
                                                                builder: (context,
                                                                        state,
                                                                        _) =>
                                                                    WillPopScope(
                                                                  onWillPop:
                                                                      () async {
                                                                    Provider.of<ApplicationState>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .logOut();
                                                                    return true;
                                                                  },
                                                                  child:
                                                                      LoginScreen(
                                                                    state:
                                                                        state,
                                                                    canBack:
                                                                        true,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                        },
                                                        buttonTitle:
                                                            "Login Now",
                                                        textStyle:
                                                            Constraint.Nunito(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                        height: 50)
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      }
                                    },
                                    buttonTitle: "Select",
                                    textStyle: Constraint.Nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    height: 60);
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
