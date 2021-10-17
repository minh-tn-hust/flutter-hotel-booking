import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/host_hotel_info.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/room_info.dart/host_room_info.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/room_or_hotel.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/top_bar.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:provider/provider.dart';

class HostHotelRoom extends StatefulWidget {
  final void Function() callBack;
  const HostHotelRoom({
    Key? key,
    required this.callBack,
  }) : super(key: key);

  @override
  HostHotelRoomState createState() => HostHotelRoomState();
}

class HostHotelRoomState extends State<HostHotelRoom> {
  bool isHotel = true;
  late Hotel hotel;
  PageController hotelRoomPageController = new PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    hotelRoomPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hotel = Provider.of<SelectedHotel>(context).selectedHotel!;
    print("Host_Frame - HotelTab - HostHotelRoom - rebuild");
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 180,
                  ),
                  TopBar(
                    hotelName: hotel.name!,
                    isVerify: !(hotel.verify == null),
                  ),
                  Positioned(
                    top: 120,
                    left: 30,
                    right: 30,
                    child: RoomOrHotel(
                      callBack: (isHotel) {
                        setState(() {
                          this.isHotel = isHotel;
                        });
                      },
                      isHotel: isHotel,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: (isHotel)
                    ? HostHotelInfo(
                        callBack: () {
                          widget.callBack();
                          setState(() {
                            isHotel = !isHotel;
                          });
                        },
                      )
                    : HostRoomInfo(
                        callBack: () {
                          widget.callBack();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
