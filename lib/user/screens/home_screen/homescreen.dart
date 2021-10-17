import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/test.dart';
import 'package:hotel_booking_app/user/screens/home_screen/widgets/recommended/recommended.dart';
import 'package:hotel_booking_app/user/screens/home_screen/widgets/title_and_search/title_and_search.dart';

class HomeScreen extends StatefulWidget {
  final Function() callBack;
  const HomeScreen({
    Key? key,
    required this.callBack,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ListView(
        shrinkWrap: true,
        children: [
          TitleAndSearch(
            callBack: () {
              widget.callBack();
            },
          ),
          Recommended(
            children: Testing.hotelData,
          ),
        ],
      ),
    );
  }
}
