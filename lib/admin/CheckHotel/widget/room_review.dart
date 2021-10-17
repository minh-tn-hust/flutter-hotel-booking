import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/user/screens/book_room/widgets/feature_row.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_preview.dart';

class RoomReview extends StatefulWidget {
  const RoomReview({
    Key? key,
    required this.room,
  }) : super(key: key);
  final Room room;

  @override
  _RoomReviewState createState() => _RoomReviewState();
}

class _RoomReviewState extends State<RoomReview> {
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
                          width: 340,
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
                                widget.room.amenities!.length > 4
                                    ? 4
                                    : widget.room.amenities!.length, (index) {
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
                        if (widget.room.amenities!.length > 4)
                          Text(
                            "More ${widget.room.amenities!.length - 4} extensions",
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
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
