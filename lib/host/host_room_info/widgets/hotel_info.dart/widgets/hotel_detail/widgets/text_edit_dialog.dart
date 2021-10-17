import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

class TextEditDialog extends StatelessWidget {
  const TextEditDialog({
    Key? key,
    required this.field,
    required this.content,
    required this.docId,
    required this.callBack,
    this.width,
    this.height,
    this.maxChar,
    this.maxLine,
    this.isRoom,
    this.roomIndex,
  }) : super(key: key);

  final void Function(String value) callBack;
  final String field;
  final String content;
  final String docId;
  final double? width;
  final double? height;
  final int? maxLine;
  final int? maxChar;
  final bool? isRoom;
  final int? roomIndex;

  Future<String> updateDb(
      String field, String content, BuildContext context) async {
    String status;
    if (isRoom == null)
      status = await Provider.of<SelectedHotel>(context, listen: false)
          .updateInfo(field, content);
    else
      status = await Provider.of<SelectedHotel>(context, listen: false)
          .updateRoomInfo(field, content, roomIndex!);
    if (status == "Done")
      return "Done";
    else
      return status;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> mapTitle = {
      "imagePath": "Image",
      "title": "Hotel Name",
      "amenities": "Amenities",
      "recentAvailable": "Rooms available",
      "price": "Price",
      "roomId": "RoomId",
      "rooms": "Rooms",
      "location": "Location",
      "name": "Hotel Name",
      "lowestPrice": "Lowest Price",
      "highestPrice": "Highest Price",
      "description": "Description",
      "type": "Type",
    };
    TextEditingController controller = TextEditingController(text: content);
    return Dialog(
      insetPadding:
          (maxChar != null) ? EdgeInsets.only(left: 10, right: 10) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: height ?? 175,
        width: width ?? 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mapTitle[field]!,
              style: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextFormField(
              controller: controller,
              maxLength: maxChar ?? 50,
              maxLines: maxLine ?? 1,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
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
                if (!field.toString().contains("Price"))
                  CustomButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return FutureBuilder(
                                future:
                                    updateDb(field, controller.text, context),
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
                                            callBack(controller.text);
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
            )
          ],
        ),
      ),
    );
  }
}
