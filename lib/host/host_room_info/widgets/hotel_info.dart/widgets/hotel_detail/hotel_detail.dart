import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/edit_amenities.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/edit_image.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/edit_location.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/text_edit_dialog.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_page.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/pick_image/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../constraint.dart';

class HotelDetail extends StatefulWidget {
  const HotelDetail({
    Key? key,
    required this.title,
    required this.content,
    required this.docId,
    required this.callBack,
    // required this.callBack;
  }) : super(key: key);
  final dynamic title;
  final dynamic content;
  final String docId;
  final void Function() callBack;
  // final void Function() callBack;
  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  final TextStyle titleStyle = Constraint.Nunito(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  final TextStyle contentStyle = Constraint.Nunito(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
  Map<String, String> mapTitle = {
    "imagePath": "Image",
    "rooms": "Rooms",
    "location": "Location",
    "name": "Name",
    "lowestPrice": "Lowest Price",
    "highestPrice": "Highest Price",
    "description": "Description",
    "type": "Type",
    "amenities": "Amenities",
  };
  String? title;
  String? content;
  @override
  void initState() {
    // TODO: implement initState
    title = widget.title.toString();
    content = widget.content.toString();
    super.initState();
  }

  Widget rooms(dynamic rooms) {
    List<Room> listRoom = [];
    (rooms as List<Map<String, dynamic>>).forEach((element) {
      listRoom.add(Room.fromJson(element));
    });
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          listRoom.length,
          (index) => Text(
            "- ${listRoom[index].title!}",
            style: contentStyle,
          ),
        ),
      ),
    );
  }

  Widget location(dynamic content) {
    Location location =
        Location.fromFirebaseJson(content as Map<String, dynamic>);
    return Container(
      child: Text(
        location.text,
        style: contentStyle,
      ),
    );
  }

  Widget amenities(List<String> amenities) {
    return Container(
      height: amenities.length / 3 * 75,
      child: SizedBox.expand(
        child: ListView(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              children: List.generate(amenities.length, (index) {
                return Container(
                  height: 50,
                  width: 90,
                  child: Amenity(
                    isTitle: true,
                    amenity: IconLib.iconHotelLib.keys.elementAt(index),
                    onTap: () {},
                    check: true,
                    imagePath: IconLib.iconHotelLib[amenities[index]]!,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget image(List<String> imagePath) {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          imagePath.length,
          (index) => Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ImagePage(
                  addressList: imagePath,
                  index: index,
                  height: 100,
                  width: 200,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetFromField(String field, dynamic content) {
    switch (field) {
      case "imagePath":
        return image(content);
      case "amenities":
        return amenities(content);
      case "location":
        return location(content);
      case "rooms":
        return rooms(content);
      default:
        return Text(
          widget.content.toString(),
          style: contentStyle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("$title");
    return ListTile(
      title: Text(
        mapTitle[title.toString()]!,
        style: titleStyle,
      ),
      subtitle: widgetFromField(title!, widget.content),
      trailing:
          (widget.title != "highestPrice" && widget.title != "lowestPrice")
              ? IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    if (title == "rooms") {
                      widget.callBack();
                    } else
                      showDialog(
                          context: context,
                          builder: (context) {
                            switch (title) {
                              case "location":
                                return EditLocation(content: widget.content);
                              case "imagePath":
                                return EditImage(
                                  imagePath: widget.content,
                                );
                              case "amenities":
                                return AmenitiesEdit(amenities: widget.content);
                              case "description":
                                return TextEditDialog(
                                    height: 310,
                                    width: 350,
                                    maxChar: 500,
                                    maxLine: 8,
                                    field: widget.title.toString(),
                                    content: widget.content.toString(),
                                    docId: widget.docId,
                                    callBack: (value) {});
                              default:
                                return TextEditDialog(
                                    field: widget.title.toString(),
                                    content: widget.content.toString(),
                                    docId: widget.docId,
                                    callBack: (value) {});
                            }
                          });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xff5b7ac7),
                  ),
                )
              : null,
    );
  }
}
