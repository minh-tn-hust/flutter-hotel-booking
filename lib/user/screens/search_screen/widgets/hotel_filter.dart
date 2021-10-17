import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';

class HotelFilter extends StatefulWidget {
  const HotelFilter({Key? key}) : super(key: key);

  @override
  _HotelFilterState createState() => _HotelFilterState();
}

class _HotelFilterState extends State<HotelFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackButtonAndTitle(title: "Filter"),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
            Row(
              children: [
                Text("Your budget"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
