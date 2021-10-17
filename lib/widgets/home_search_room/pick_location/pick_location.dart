import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/widgets/home_search_room/pick_location/auto_complete_search.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../../constraint.dart';

class PickLocation extends StatefulWidget {
  final Location? location;
  final Function(Location location) setLocation;
  const PickLocation({
    Key? key,
    required this.setLocation,
    required this.location,
  }) : super(key: key);

  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  Location? location;
  @override
  void initState() {
    location = widget.location;
    super.initState();
  }

  void _showBottomShet(
      BuildContext context, void Function(Location val) pickItem) {
    var textController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        height: 750,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: AutoCompleteSearch(
          pickItem: (Location picker) {
            widget.setLocation(picker);
            setState(() {
              location = picker;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showBottomShet(context, (val) {
          setState(() {
            location = val;
          });
        });
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 14,
        ),
        height: 50,
        width: 230,
        decoration: BoxDecoration(
            color: Color.fromRGBO(223, 222, 222, 0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            (location == null) ? "Place" : location!.text,
            style: Constraint.Nunito(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
        ),
      ),
    );
  }
}
