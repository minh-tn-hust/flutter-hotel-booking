import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';

class Detail extends StatelessWidget {
  const Detail({
    Key? key,
    required this.detail,
  }) : super(key: key);
  final String detail;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: SvgPicture.asset(
                IconLib.iconHotelLib[detail]!,
                color: Colors.black,
                width: 16,
              ),
            ),
            SizedBox(
              width: 13,
            ),
            Text(
              "${detail}",
              style: Constraint.Nunito(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color(0xFF999999),
              ),
            )
          ],
        ),
        SizedBox(
          height: 13,
        ),
      ],
    );
  }
}
