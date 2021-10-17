import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../../../../../constraint.dart';

class AmenitiesEdit extends StatefulWidget {
  final List<String> amenities;
  final bool? isRoom;
  final int? roomIndex;
  const AmenitiesEdit({
    Key? key,
    required this.amenities,
    this.roomIndex,
    this.isRoom,
  }) : super(key: key);

  @override
  _AmenitiesEditState createState() => _AmenitiesEditState();
}

class _AmenitiesEditState extends State<AmenitiesEdit> {
  List<String>? amenities;
  @override
  void initState() {
    // TODO: implement initState
    amenities = widget.amenities.map((e) => e).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var content =
        (widget.isRoom == null) ? IconLib.iconHotelLib : IconLib.iconRoomLib;
    return Dialog(
      insetPadding: EdgeInsets.only(left: 10, right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        height: 535,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change your hotel amenities",
              style: Constraint.Nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(content.length, (index) {
                      return Container(
                        height: 100,
                        width: 150,
                        child: Amenity(
                            amenity: content.keys.elementAt(index),
                            onTap: () {
                              var check = amenities!
                                  .contains(content.keys.elementAt(index));
                              setState(() {
                                if (check == false) {
                                  amenities!.add(content.keys.elementAt(index));
                                } else
                                  amenities!.removeWhere((element) =>
                                      element == content.keys.elementAt(index));
                              });
                            },
                            check: amenities!
                                .contains(content.keys.elementAt(index)),
                            imagePath: content.values.elementAt(index)),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    buttonTitle: "Cancel",
                    textStyle: Constraint.Nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    height: 30,
                  ),
                  Spacer(),
                  CustomButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return FutureBuilder(
                                future: (widget.isRoom == null)
                                    ? Provider.of<SelectedHotel>(context,
                                            listen: false)
                                        .updateInfo("amenities", amenities)
                                    : Provider.of<SelectedHotel>(context,
                                            listen: false)
                                        .updateRoomInfo("amenities", amenities,
                                            widget.roomIndex!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  if (snapshot.data == "Done") {
                                    return AlertDialog(
                                      actions: [
                                        CustomButton(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          buttonTitle: "Confirm",
                                          textStyle: Constraint.Nunito(
                                            fontSize: 14,
                                          ),
                                          height: 30,
                                        ),
                                      ],
                                      title: Text(
                                        "Done",
                                        style: Constraint.Nunito(),
                                      ),
                                      content: Text(
                                        "Your data has been updated",
                                        style: Constraint.Nunito(),
                                      ),
                                    );
                                  } else {
                                    return AlertDialog(
                                      actions: [
                                        CustomButton(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          buttonTitle: "Confirm",
                                          textStyle: Constraint.Nunito(
                                            fontSize: 14,
                                          ),
                                          height: 30,
                                        ),
                                      ],
                                      title: Text(
                                        "Error",
                                        style: Constraint.Nunito(),
                                      ),
                                      content: Text(
                                        "${snapshot.data}",
                                        style: Constraint.Nunito(),
                                      ),
                                    );
                                  }
                                });
                          });
                    },
                    buttonTitle: "Save",
                    textStyle: Constraint.Nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
