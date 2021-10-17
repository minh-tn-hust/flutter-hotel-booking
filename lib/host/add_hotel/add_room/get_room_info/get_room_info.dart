import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/icons/icon_lib.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/pick_image/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GetRoomInfo extends StatefulWidget {
  const GetRoomInfo({
    Key? key,
    required this.index,
    required this.room,
    required this.callBack,
    this.isEdit,
  }) : super(key: key);

  final int index;
  final Room? room;
  final bool? isEdit;
  final void Function() callBack;
  @override
  _GetRoomInfoState createState() => _GetRoomInfoState();
}

class _GetRoomInfoState extends State<GetRoomInfo> {
  List<bool> amenities =
      List.generate(IconLib.iconRoomLib.length, (index) => false);
  List<PickedFile?> _listImageFile = List.generate(5, (index) => null);
  TextEditingController? roomType;
  TextEditingController? roomAvailable;
  TextEditingController? price;
  Room? room;

  final _keyForm = GlobalKey<FormState>();

  final _picker = ImagePicker();
  void getImage(int index) async {
    // Hàm dùng để có thể cho phép người dùng lấy ảnh từ thư viện
    var imagefile = await _picker.getImage(source: ImageSource.gallery);
    if (imagefile != null)
      setState(() {
        _listImageFile[index] = imagefile;
      });
  }

  @override
  void dispose() {
    roomType!.dispose();
    roomAvailable!.dispose();
    price!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // lấy đối tượng mà người dùng muốn chỉnh sửa
    room = widget.room;

    // lấy dữ liệu đầu vào, nếu như không có thì là thêm khách sạn mới, có thì là chỉnh sửa khách sạn

    roomType = TextEditingController(
      text: (room!.title == null) ? null : room!.title,
    ); // lấy tên phòng, nếu như phòng mới thì để null

    roomAvailable = TextEditingController(
      text: (room!.recentAvailable == null)
          ? null
          : room!.recentAvailable.toString(),
    );

    price = TextEditingController(
      text: (room!.price == null) ? null : room!.price.toString(),
    );
    // khởi tạo lấy dữ liệu từ những khách sạn đã được khai báo ở trên (nếu không thì tất cả phần tử _listImageFile == null hết)
    for (int i = 0; i < _listImageFile.length; i++) {
      if (widget.room!.imagePath![i] != "")
        _listImageFile[i] = new PickedFile(widget
            .room!.imagePath![i]); // tạo đối tượng với đường dẫn được cung cấp
    }

    for (int i = 0; i < room!.amenities!.length; i++) {
      var source = IconLib.iconRoomLib.keys.toList();
      amenities[source.indexWhere(
          (element) => element.compareTo(room!.amenities![i]) == 0)] = true;
    }
  }

  String? _validateNumber(String? value) {
    if (value == null) {
      return "Please fill your information";
    }
    if (value.isEmpty) {
      return "Please fill your information";
    }
    if (!value.contains(RegExp(r'^[0-9]*$'))) {
      return "Only number in here";
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null) {
      return "Please fill your information";
    }
    if (value.isEmpty) {
      return "Please fill your information";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ListView(
                    children: [
                      Text(
                        "Get Room Info",
                        style: Constraint.Nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            TextFormField(
                              scrollPadding: EdgeInsets.only(left: 5, right: 5),
                              validator: _validateName,
                              controller: roomType,
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffebded4),
                                labelText: "Room type",
                                labelStyle: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: _validateNumber,
                              controller: roomAvailable,
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffebded4),
                                labelText: "Recent room available",
                                labelStyle: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: _validateNumber,
                              controller: price,
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffebded4),
                                suffix: Text(
                                  "\$ ",
                                  style: Constraint.Nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                labelText: "Price",
                                labelStyle: Constraint.Nunito(
                                  fontSize: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Up load image",
                        style: Constraint.Nunito(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          children: [
                            PickImage(
                              // container lấy ảnh
                              callBack: () {
                                getImage(0);
                                // lấy ảnh vào vị trí thứ nhất trong list ảnh
                              },
                              file: _listImageFile[
                                  0], // gửi path ảnh vào _listImageFile[0]
                              height: 180,
                              width: 360,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              // tiếp theo là 4 ảnh phụ
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(4, (index) {
                                return PickImage(
                                  file: _listImageFile[index + 1],
                                  callBack: () {
                                    getImage(index + 1);
                                  },
                                  height: 90,
                                  width: 180,
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        // thêm các tính năng cho phòng bằng việc pick
                        "Room Amenities",
                        style: Constraint.Nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Wrap(
                          // gọi ra các tính năng được app mình cung cấp (source lấy từ IconLib)
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            IconLib.iconRoomLib.length,
                            (index) {
                              return Amenity(
                                check: amenities[index],
                                onTap: () {
                                  amenities[index] = !amenities[index];
                                },
                                amenity:
                                    IconLib.iconRoomLib.keys.elementAt(index),
                                imagePath:
                                    IconLib.iconRoomLib.values.elementAt(index),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
                height: 80,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                child: CustomButton(
                  onTap: () {
                    int j = 0;
                    int count = 0;
                    for (int i = 0; i < 5; i++) {
                      if (_listImageFile[i] == null)
                        count++;
                      else
                        room!.imagePath![j++] = _listImageFile[i]!.path;
                    }
                    for (int i = 0; i < IconLib.iconRoomLib.length; i++) {
                      if (amenities[i] == true)
                        room!.amenities!
                            .add(IconLib.iconRoomLib.keys.elementAt(i));
                    }
                    if (count != 0 && room!.amenities!.length == 0) {
                      showDialog(
                          context: context,
                          builder: (context) {
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
                                "Your room need to uploaded image and choose amenities",
                                style: Constraint.Nunito(),
                              ),
                            );
                          });
                    } else if (_keyForm.currentState!.validate()) {
                      room!.title = roomType!.text;
                      room!.price = double.parse(price!.text);
                      room!.recentAvailable = int.parse(roomAvailable!.text);
                      if (widget.isEdit != null) {
                        print("true");
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FutureBuilder(
                                  future: Provider.of<SelectedHotel>(context,
                                          listen: false)
                                      .addRoom(room!),
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
                                              widget.callBack();
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
                                          "Your room has been uploaded",
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
                      } else if (widget.index == -1) {
                        Provider.of<HotelProvider>(context, listen: false)
                            .addRoom(room!);
                        Navigator.of(context).pop();
                      } else {
                        Provider.of<HotelProvider>(context, listen: false)
                            .updateRoomIndex(room!, widget.index);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  buttonTitle: "Add room",
                  textStyle: Constraint.Nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
