import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';

class TopBar extends StatefulWidget {
  final String hotelName;
  final bool isVerify;
  const TopBar({
    Key? key,
    required this.hotelName,
    required this.isVerify,
  }) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFf4610b), Color(0xFFffb61a)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 50,
            width: 50,
            // child: Icon(Icons.arrow_back),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            children: [
              Text(
                widget.hotelName,
                style: Constraint.Nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.verified,
                  color: (widget.isVerify) ? Colors.blue : Colors.red,
                  size: 30,
                ),
                tooltip: (widget.isVerify)
                    ? "Your hotel can be booked now"
                    : "Wait for verifing",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
