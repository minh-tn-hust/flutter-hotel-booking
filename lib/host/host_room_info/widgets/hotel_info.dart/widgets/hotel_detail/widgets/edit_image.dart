import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/pick_image/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../../constraint.dart';
import '../../../../../../../main.dart';

class EditImage extends StatefulWidget {
  const EditImage({
    Key? key,
    required this.imagePath,
    this.isRoom,
    this.roomIndex,
  }) : super(key: key);
  final List<String> imagePath;
  final bool? isRoom;
  final int? roomIndex;
  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  List<String>? imagePath;
  @override
  void initState() {
    // TODO: implement initState
    imagePath = widget.imagePath.map((e) => e).toList();
    print("widget imagePath ${widget.imagePath.hashCode}");
    print("image path ${imagePath.hashCode}");
    super.initState();
  }

  void getImage() async {
    // Hàm dùng để có thể cho phép người dùng lấy ảnh từ thư viện
    var _picker = ImagePicker();
    var imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (imagefile != null) {
      setState(() {
        imagePath!.add(imagefile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              "Change your image",
              style: Constraint.Nunito(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Preview",
              style: Constraint.Nunito(
                fontSize: 18,
              ),
            ),
            Container(
              height: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          if (imagePath!.length != 0)
                            Stack(
                              children: [
                                PickImage(
                                  file: imagePath![0].contains("http")
                                      ? null
                                      : PickedFile(imagePath![0]),
                                  callBack: () {},
                                  height: 200,
                                  width: 400,
                                  url: imagePath![0].contains("http")
                                      ? imagePath![0]
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        imagePath!.removeAt(0);
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (imagePath!.length != 0)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                imagePath!.length - 1,
                                (index) => Stack(
                                  children: [
                                    PickImage(
                                      file: imagePath![index + 1]
                                              .contains("http")
                                          ? null
                                          : PickedFile(imagePath![index + 1]),
                                      callBack: () {},
                                      height: 100,
                                      width: 165,
                                      url: (imagePath![index + 1]
                                              .contains("http"))
                                          ? imagePath![index + 1]
                                          : null,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imagePath!.removeAt(index + 1);
                                          });
                                        },
                                        icon: Icon(Icons.remove_circle),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              onTap: () {
                getImage();
              },
              buttonTitle: "Add more",
              textStyle: Constraint.Nunito(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              height: 50,
            ),
            SizedBox(
              height: 15,
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
                      if (imagePath!.length > 5) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
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
                                    "Limited 5 image for per hotel",
                                    style: Constraint.Nunito(),
                                  ),
                                ));
                      } else
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FutureBuilder(
                                  future: (widget.isRoom == null)
                                      // update ảnh cho hotel
                                      ? Provider.of<SelectedHotel>(context,
                                              listen: false)
                                          .updateImagePath(imagePath!)
                                      // update ảnh cho  room
                                      : Provider.of<SelectedHotel>(context,
                                              listen: false)
                                          .updateRoomImage(
                                              imagePath!, widget.roomIndex!),
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
