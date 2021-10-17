import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/widgets/home_search_room/home_search_room.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchInformationBar extends StatelessWidget {
  const SearchInformationBar({
    Key? key,
    required this.mapController,
    required this.model,
    required this.location,
    required this.guests,
    required this.beginDate,
    required this.endDate,
  }) : super(key: key);
  final MapController mapController;
  final SearchInfoModel model;
  final Location? location;
  final int? guests;
  final DateTime? beginDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            context: context,
            builder: (context) {
              return HomeSearchRoom(
                callBack: () {
                  Navigator.of(context).pop();
                  mapController.move(
                      Provider.of<SearchModel>(context, listen: false).location,
                      13);
                },
                searchInfo: model,
              );
            });
      },
      child: Column(
        children: [
          // Search bar for tab search
          Container(
            padding: EdgeInsets.only(
              left: 6,
              right: 6,
            ),
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                (location != null &&
                        guests != null &&
                        beginDate != null &&
                        endDate != null)
                    ? Text(
                        "${location!.text} - ${guests!} - ${DateFormat.MMMd().format(beginDate!)} to ${DateFormat.MMMd().format(endDate!)}",
                        style: Constraint.Nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : Text(
                        "Search where you want to go ...",
                        style: Constraint.Nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                Expanded(
                  child: Container(),
                ),
                Icon(Icons.more_sharp),
              ],
            ),
          )
        ],
      ),
    );
  }
}
