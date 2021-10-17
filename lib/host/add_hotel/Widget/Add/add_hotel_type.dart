import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_description.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_image.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/selected_button/selected_button.dart';
import 'package:provider/provider.dart';

class ChooseHotelType extends StatefulWidget {
  const ChooseHotelType({
    Key? key,
    required this.type,
    required this.descriptionController,
    required this.nameController,
  }) : super(key: key);
  final int? type;
  final TextEditingController descriptionController;
  final TextEditingController nameController;
  @override
  _ChooseHotelTypeState createState() => _ChooseHotelTypeState();
}

class _ChooseHotelTypeState extends State<ChooseHotelType> {
  bool isHomeStay = true;

  @override
  void initState() {
    isHomeStay = (widget.type == 0);
    super.initState();
  }

  String platform = "hotel";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      "",
                      style: Constraint.Nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kind of $platform:",
                          style: Constraint.Nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SelectedButton(
                                  selected: !isHomeStay,
                                  height: 50,
                                  title: Text(
                                    "Hotel",
                                    style: Constraint.Nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<HotelProvider>(context,
                                            listen: false)
                                        .updateType(1);
                                    setState(() {
                                      platform = "hotel";
                                      isHomeStay = false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: SelectedButton(
                                  selected: isHomeStay,
                                  height: 50,
                                  title: Text(
                                    "Homestay",
                                    style: Constraint.Nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<HotelProvider>(context,
                                            listen: false)
                                        .updateType(0);
                                    setState(() {
                                      platform = "homestay";
                                      isHomeStay = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${platform.replaceFirst(platform[0], platform[0].toUpperCase())} Information:",
                          style: Constraint.Nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AddHotelDescription(
                          descriptionCtrl: widget.descriptionController,
                          nameCtrl: widget.nameController,
                          type: platform,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add your $platform image:",
                          style: Constraint.Nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AddHotelImage(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add your $platform amenities:",
                          style: Constraint.Nunito(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        PickHotelAmenities(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
