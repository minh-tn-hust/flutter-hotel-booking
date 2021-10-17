import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/add_room/get_room_info/get_room_info.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:provider/provider.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({Key? key}) : super(key: key);

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  @override
  Widget build(BuildContext context) {
    var hotel = Provider.of<HotelProvider>(context, listen: false).addHotel;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "What type of \nrooms do you have", // Phần câu hỏi
              style: Constraint.Nunito(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SizedBox.expand(
              child: ListView(
                padding: EdgeInsets.only(top: 10),
                children: List.generate(hotel!.rooms!.length + 1, (index) {
                  if (index != hotel.rooms!.length) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RoomTab(
                          room: hotel.rooms![index],
                          index: index,
                          callBack: () {},
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  } else
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GetRoomInfo(
                              room: new Room(
                                imagePath: List.generate(5, (index) => ""),
                                amenities: [],
                              ),
                              index: -1,
                              callBack: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: Icon(Icons.add),
                      ),
                    );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomTab extends StatelessWidget {
  const RoomTab({
    required this.room,
    Key? key,
    required this.index,
    required this.callBack,
  }) : super(key: key);
  final Room room;
  final int index;
  final void Function() callBack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GetRoomInfo(
              callBack: () {
                callBack();
              },
              room: room,
              index: index,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        // height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: FileImage(File(room.imagePath![0])),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 220,
              child: Text(
                room.title!,
                style: Constraint.Nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Provider.of<HotelProvider>(context, listen: false)
                      .deleteRoomIndex(index);
                },
                icon: Icon(
                  Icons.delete_forever,
                  size: 20,
                  color: Colors.grey,
                ))
          ],
        ),
      ),
    );
  }
}
