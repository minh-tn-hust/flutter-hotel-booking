import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';

class RoomOrHotel extends StatefulWidget {
  const RoomOrHotel({
    Key? key,
    required this.callBack,
    required this.isHotel,
  }) : super(key: key);
  final void Function(bool isHotel) callBack;
  final bool isHotel;

  @override
  _RoomOrHotelState createState() => _RoomOrHotelState();
}

class _RoomOrHotelState extends State<RoomOrHotel> {
  late bool isHotel;
  final Color enable = Colors.orangeAccent;
  final Color disable = Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    isHotel = widget.isHotel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isHotel != widget.isHotel) isHotel = widget.isHotel;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 0.2,
            color: Colors.black38,
          )
        ],
      ),
      height: 60,
      width: 300,
      child: Row(
        children: [
          Expanded(
            // hotel button
            child: InkWell(
              onTap: () {
                setState(() {
                  isHotel = true;
                  widget.callBack(isHotel);
                });
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: (isHotel) ? enable : disable,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Hotel Info",
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (isHotel) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            // rooms infor button
            child: InkWell(
              onTap: () {
                setState(() {
                  isHotel = false;
                  widget.callBack(isHotel);
                });
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: (!isHotel) ? enable : disable,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Center(
                    child: Text(
                      "Rooms Info",
                      style: Constraint.Nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (!isHotel) ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
