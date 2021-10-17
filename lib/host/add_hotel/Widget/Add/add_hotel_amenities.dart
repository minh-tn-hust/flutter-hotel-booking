import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:provider/provider.dart';

class PickHotelAmenities extends StatefulWidget {
  const PickHotelAmenities({
    Key? key,
  }) : super(key: key);
  @override
  PickHotelAmenitiesState createState() => PickHotelAmenitiesState();
}

class PickHotelAmenitiesState extends State<PickHotelAmenities> {
  List<bool> amenities = List.filled(10, false);

  @override
  void initState() {
    super.initState();
    //
  }

  @override
  Widget build(BuildContext context) {
    late List<String> amenitiesTile =
        Provider.of<HotelProvider>(context).addHotel!.amenities!;

    // gắn dữ liệu từ provider vào state của PickHotelAmenities
    // ở đây các tính năng của Hotel được biểu diễn dưới dạng mảng bool (cái nào có thì true, cái nào không có thì false)
    // gắn dữ liệu từ List<String> -> List<bool> theo thứ tự mà IconLib cung cấp
    int index = 0;
    int i = 0;
    var source = IconLib.iconHotelLib.keys.toList();
    for (var record in amenitiesTile) {
      amenities[source
          .indexWhere((element) => element.compareTo(record) == 0)] = true;
    }
    //================================
    return Container(
      height: 565,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
            child: Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  10,
                  (index) {
                    return Amenity(
                      check: amenities[index],
                      onTap: () {
                        amenities[index] = !amenities[index];
                        Provider.of<HotelProvider>(context, listen: false)
                            .updateAmenities(
                                IconLib.iconHotelLib.keys.elementAt(index),
                                amenities[index]);
                        // hàm updateAmenities nhận 2 tham số, 1 là tên tính năng, 2 là true/false, nếu true -> add, còn false -> remove
                      },
                      amenity: IconLib.iconHotelLib.keys.elementAt(index),
                      imagePath: IconLib.iconHotelLib.values.elementAt(index),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Amenity extends StatefulWidget {
  // phần cài đặt các ôn tính năng dành cho khách sạn và phòng
  const Amenity({
    Key? key,
    required this.amenity,
    required this.onTap,
    required this.check,
    required this.imagePath,
    this.isTitle,
  }) : super(key: key);
  final String amenity;
  final void Function() onTap;
  final bool check;
  final String imagePath;
  final bool? isTitle;

  @override
  _AmenityState createState() => _AmenityState();
}

class _AmenityState extends State<Amenity> {
  bool check = false;
  @override
  void initState() {
    check = widget.check;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          check = !check;
        });
      },
      child: Container(
        padding: EdgeInsets.all(5),
        height: 100,
        width: 170,
        decoration: BoxDecoration(
          color: (check == true) ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (check == true) ? Colors.black : Colors.grey.shade500,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.imagePath,
                color: Colors.black,
                height: 25,
                width: 25,
              ),
              SizedBox(
                height: 5,
              ),
              if (widget.isTitle == null)
                Text(
                  "${widget.amenity}",
                  textAlign: TextAlign.center,
                  style: Constraint.Nunito(
                    fontSize: 15,
                    fontWeight:
                        (check == true) ? FontWeight.bold : FontWeight.normal,
                  ),
                  softWrap: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
