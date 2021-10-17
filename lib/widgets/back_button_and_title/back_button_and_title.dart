import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';

class BackButtonAndTitle extends StatelessWidget {
  const BackButtonAndTitle({Key? key, required this.title, this.needBackgournd})
      : super(key: key);
  final bool? needBackgournd;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 20,
      ),
      decoration: BoxDecoration(
        gradient: (needBackgournd != null)
            ? LinearGradient(
                colors: [Color(0xFFf4610b), Color(0xFFffb61a)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: 30,
              child: Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            width: 18,
          ),
          Text(
            "$title",
            style: Constraint.Nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: (needBackgournd != null) ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
