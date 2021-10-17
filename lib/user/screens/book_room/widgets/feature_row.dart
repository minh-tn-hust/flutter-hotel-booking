import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';

class FeatureRow extends StatelessWidget {
  final String content;
  const FeatureRow({
    Key? key,
    required this.content,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          IconLib.iconRoomLib[content]!,
          color: Colors.grey,
          height: 22,
          width: 22,
        ),
        SizedBox(width: 15),
        Text(
          content,
          style: Constraint.Nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
