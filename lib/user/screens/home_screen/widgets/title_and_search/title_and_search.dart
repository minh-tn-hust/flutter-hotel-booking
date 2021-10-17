import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/widgets/home_search_room/home_search_room.dart';
import 'package:provider/provider.dart';


class TitleAndSearch extends StatelessWidget {
  final Function() callBack;
  const TitleAndSearch({
    Key? key,
    required this.callBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 488,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/home_background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 43, top: 52),
            child: Text(
              "Find a perfect place to stay",
              style: Constraint.HomeHeader,
            ),
          ),
        ),
        Positioned(
          top: 188,
          left: 0,
          right: 0,
          child: Consumer<SearchModel>(
            builder: (context, model, _) {
              return HomeSearchRoom(
                callBack: () {
                  callBack();
                },
                searchInfo: model.searchState!,
              );
            },
          ),
        )
      ],
    );
  }
}
