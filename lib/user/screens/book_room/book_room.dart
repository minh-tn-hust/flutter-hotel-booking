import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/user/screens/book_room/widgets/room_infor_card.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';

class BookRoom extends StatefulWidget {
  const BookRoom({
    Key? key,
    required this.children,
    required this.title,
  }) : super(key: key);

  final String title;
  final List<Room> children;

  @override
  _BookRoomState createState() => _BookRoomState();
}

class _BookRoomState extends State<BookRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDFDEDE),
      body: SafeArea(
        child: Column(
          children: [
            BackButtonAndTitle(
              title: widget.title,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 15),
                child: (widget.children.length != 0)
                    ? ListView.builder(
                        itemCount: widget.children.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RoomInforCard(
                                room: widget.children[index],
                              ),
                              SizedBox(height: 15),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "This hotel haven't room",
                          style: Constraint.Nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
