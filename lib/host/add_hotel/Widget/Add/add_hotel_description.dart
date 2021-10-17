import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:provider/provider.dart';

class AddHotelDescription extends StatefulWidget {
  final TextEditingController descriptionCtrl;
  final TextEditingController nameCtrl;
  final String type;
  const AddHotelDescription({
    Key? key,
    required this.descriptionCtrl,
    required this.type,
    required this.nameCtrl,
  }) : super(key: key);

  @override
  _AddHotelDescriptionState createState() => _AddHotelDescriptionState();
}

class _AddHotelDescriptionState extends State<AddHotelDescription> {
  int currentLength = 0;
  @override
  Widget build(BuildContext context) {
    String? description =
        Provider.of<HotelProvider>(context).addHotel!.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 362,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  autofocus: true,
                  controller: widget.nameCtrl,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Your ${widget.type.toLowerCase()}'s name",
                    labelStyle: Constraint.Nunito(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  autofocus: true,
                  maxLength: 250,
                  controller: widget.descriptionCtrl,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                  },
                  decoration: InputDecoration(
                    counterText: currentLength.toString(),
                    counterStyle: Constraint.Nunito(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(),
                    hintText: description ??
                        "Add some description about your ${widget.type.toLowerCase()}...",
                  ),
                  maxLines: 15,
                  minLines: 10,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
