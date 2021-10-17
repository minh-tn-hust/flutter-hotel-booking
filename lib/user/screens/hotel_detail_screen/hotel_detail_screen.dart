import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/book_room/book_room.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/hotel_info.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_preview.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/static_map.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/star_rate/star_rate.dart';
import 'package:provider/provider.dart';

import '../../../constraint.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final Hotel hotel;

  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ImagePreview(
                    imagePaths: widget.hotel.imagePath!,
                    height: 335,
                  ),
                  //edit title detail room and star
                  Container(
                    margin: EdgeInsets.only(
                      left: 17,
                      right: 17,
                      top: 20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 370,
                          child: Text(
                            "${widget.hotel.name}",
                            style: Constraint.Nunito(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 17,
                      right: 17,
                    ),
                    child: Text(
                      "${widget.hotel.location!.text}",
                      style: Constraint.Nunito(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 17,
                      right: 17,
                    ),
                    child: Text(
                      "From \$${widget.hotel.lowestPrice!} to \$${widget.hotel.highestPrice!}",
                      style: Constraint.Nunito(
                        fontSize: 24,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 17,
                      right: 17,
                    ),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Description: ",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: widget.hotel.description,
                          style: Constraint.Nunito(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: StaticMap(
                        location: widget.hotel.location!.coordinates,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      "Amenities",
                      style: Constraint.Nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),

                  //below maps
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Center(
                      child: HotelInfo(
                        children: widget.hotel.amenities!,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            //cover the button 'select rooms'
            Container(
              color: Colors.grey,
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 10,
              ),
              child: CustomButton(
                height: 70,
                onTap: () {
                  if (widget.hotel.verify != true) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text("Warning"),
                        content: Text(
                          (widget.hotel.verify == null)
                              ? "This hotel is pending confirmation, please try again later"
                              : "This hotel has been baned, you can't book this hotel",
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
                  } else {
                    Provider.of<SearchModel>(context, listen: false)
                        .updateHotel(widget.hotel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookRoom(
                          children: widget.hotel.rooms!,
                          title: widget.hotel.name!,
                        ),
                      ),
                    );
                  }
                },
                buttonTitle: "Select Rooms",
                textStyle: Constraint.Nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
