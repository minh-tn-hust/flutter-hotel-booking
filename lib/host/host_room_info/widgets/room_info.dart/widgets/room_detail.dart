import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/edit_amenities.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/edit_image.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/hotel_info.dart/widgets/hotel_detail/widgets/text_edit_dialog.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_page.dart';

import '../../../../../constraint.dart';

class RoomDetail extends StatefulWidget {
  const RoomDetail({
    Key? key,
    required this.title,
    required this.roomIndex,
    required this.content,
  }) : super(key: key);

  final dynamic title;
  final dynamic content;
  final int roomIndex;

  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
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
    "title": "Room Name",
    "amenities": "Amenities",
    "recentAvailable": "Rooms available",
    "price": "Price",
  };
  String? title;
  String? content;

  void initState() {
    // TODO: implement initState
    title = widget.title.toString();
    content = widget.content.toString();
    super.initState();
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

  Widget amenities(List<String> amenities) {
    return Container(
      height: amenities.length / 3 * 65,
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
                    amenity: amenities[index],
                    onTap: () {},
                    check: true,
                    imagePath: IconLib.iconRoomLib[amenities[index]]!,
                  ),
                );
              }),
            ),
          ],
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
      default:
        return Text(
          widget.content.toString(),
          style: contentStyle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("%%%%%%%%%%%%%%%${title.toString()}");
    return ListTile(
      title: Text(
        mapTitle[title.toString()]!,
        style: titleStyle,
      ),
      subtitle: widgetFromField(title!, widget.content),
      trailing: IconButton(
        splashRadius: 20,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                switch (title) {
                  case "imagePath":
                    return EditImage(
                      imagePath: widget.content,
                      isRoom: true,
                      roomIndex: widget.roomIndex,
                    );
                  case "amenities":
                    return AmenitiesEdit(
                      amenities: widget.content,
                      roomIndex: widget.roomIndex,
                      isRoom: true,
                    );
                  default:
                    return TextEditDialog(
                        isRoom: true,
                        roomIndex: widget.roomIndex,
                        field: widget.title.toString(),
                        content: widget.content.toString(),
                        docId: "",
                        callBack: (value) {});
                }
              });
        },
        icon: Icon(
          Icons.edit,
          color: Color(0xff5b7ac7),
        ),
      ),
    );
  }
}
