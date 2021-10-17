import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/detail.dart';

class HotelInfo extends StatelessWidget {
  const HotelInfo({
    Key? key,
    required this.children,
  }) : super(key: key);
  final List<String> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
            children.length,
            (index) => Amenity(
                amenity: children[index],
                onTap: () {},
                check: true,
                imagePath: IconLib.iconHotelLib["${children[index]}"]!)),
      ),
    );
  }
}
