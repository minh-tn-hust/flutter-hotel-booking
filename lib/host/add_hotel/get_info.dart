import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_amenities.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_description.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_image.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_location.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/Add/add_hotel_type.dart';
import 'package:hotel_booking_app/host/add_hotel/Widget/host_add_bar.dart';
import 'package:hotel_booking_app/host/add_hotel/add_room/add_room.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

class GetInfo extends StatefulWidget {
  const GetInfo({Key? key, this.callBack}) : super(key: key);
  final void Function()? callBack;

  @override
  _GetInfoState createState() => _GetInfoState();
}

class _GetInfoState extends State<GetInfo> {
  MapController mapController = new MapController();
  PageController pageController = new PageController();
  TextEditingController textController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  int index = 0;
  double zoom = 0;

  void _uploadHotel(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 100,
              width: 150,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          );
        });
    var user = await Provider.of<ApplicationState>(context, listen: false).user;
    await Provider.of<HotelProvider>(context, listen: false)
        .uploadHotel(user!.uid.toString());
    if (widget.callBack != null) widget.callBack!();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  final int LOCATION = 0;
  final int TYPE = 1;
  final int ROOMS = 2;

  @override
  Widget build(BuildContext context) {
    var hotelProvider = Provider.of<HotelProvider>(context).addHotel;
    return WillPopScope(
      onWillPop: () async {
        if (widget.callBack != null) widget.callBack!();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                      stops: [0.4, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: new NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child:
                                Container(), // đẩy phần Picklocaion xuống bên dưới, bưởi vì sử dụng li
                          ),
                          GetHotelLocation(
                            // Phần chọn vị trí khác sạn
                            mapController: mapController,
                            location: context
                                .watch<HotelProvider>()
                                .addHotel!
                                .location,
                          ),
                        ],
                      ),

                      ChooseHotelType(
                        // Phần chọn loại nhà mà muốn cho thuê
                        type: hotelProvider!.type,
                        descriptionController: textController,
                        nameController: nameController,
                      ),
                      AddRoom(),
                      // AddHotelDescription(
                      //   descriptionCtrl: textController,
                      //   nameCtrl: nameController,
                      // ),
                    ],
                  ),
                ),
                HostAddBar(
                  // Thanh gồm next và back để có thể đi tới bước tiếp theo hoặc là trở về bước trước đó
                  backCallBack: () async {
                    if (index == LOCATION) {
                      if (widget.callBack != null) widget.callBack!();
                      Navigator.of(context).pop();
                    }
                    if (index == TYPE) {
                      setState(() {
                        mapController = new MapController();
                      });
                      pageController.animateToPage(LOCATION,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linearToEaseOut);
                      index = LOCATION;
                      return;
                    }
                    if (index == ROOMS) {
                      pageController.animateToPage(TYPE,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linearToEaseOut);
                      index = TYPE;
                      return;
                    }
                  },
                  nextCallBack: () {
                    if (index == LOCATION) {
                      Provider.of<HotelProvider>(context, listen: false)
                          .updateLatLng(mapController
                              .center); // thay đổi vị trí trên map, không có thuộc tính onFinishChange nên phải đẩy về cha để xử lý
                      confirmLoction(
                          // Phần này là phần xác nhận lại vị trí của người dùng, hàm này nhận dữ liệu từ Provider để hiển thị thông tin vị trí, sau đó cập nhật lại thông tin tại Widget con luôn
                          context,
                          Provider.of<HotelProvider>(context, listen: false)
                              .addHotel!
                              .location!); // gọi modelBottomSheet lên để hể thông lại thoong tin cho người ta

                    }
                    if (index == TYPE) {
                      // phần này không cần xử lý logic bởi vì đã xử lý ở các widget con rồi
                      var amenitiesLength =
                          Provider.of<HotelProvider>(context, listen: false)
                              .addHotel!
                              .amenities!
                              .length;
                      var imagePaths =
                          Provider.of<HotelProvider>(context, listen: false)
                              .addHotel!
                              .imagePath!;
                      int imagePathLength = 0;
                      for (int i = 0; i < imagePaths.length; i++) {
                        if (imagePaths[i] == "") imagePathLength++;
                      }
                      if (amenitiesLength == 0 && imagePathLength == 5) {
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
                        return;
                      } else {
                        pageController.animateToPage(ROOMS,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linearToEaseOut);
                        index = ROOMS;
                        return;
                      }
                    }

                    if (index == ROOMS) {
                      Provider.of<HotelProvider>(context, listen: false)
                          .updateDescription(textController.text);
                      Provider.of<HotelProvider>(context, listen: false)
                          .updateName(nameController.text);
                      _uploadHotel(context);
                      return;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // BottomSheet dùng để co người dùng có thể sửa lại thông tin về địa chỉ
  Future<dynamic> confirmLoction(BuildContext context, Location location) {
    var hotelProvider =
        Provider.of<HotelProvider>(context, listen: false).addHotel;
    var fullAddress = TextEditingController(text: "${location.place_name}");
    var shortAddress = TextEditingController(text: "${location.text}");
    var areaController = TextEditingController(text: "Viet Nam");
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      isScrollControlled: true,
      builder: (contex) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 750,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  "Confirm your data",
                  style: Constraint.Nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                // Street
                controller: fullAddress,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                // text
                controller: shortAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Short Address",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                // place-name
                enabled: false,
                controller: areaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Area",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                // phần xử lý cấp nhật lại thông tin vị trí lên  provider
                onTap: () {
                  location.text = shortAddress.value.text;
                  location.place_name = fullAddress.value.text;
                  Provider.of<HotelProvider>(context, listen: false)
                      .updateLocation(
                          location); // Update Provider với vị trí mới
                  index = TYPE;
                  Navigator.of(context).pop(); // Thoát khỏi modalBottomSheet
                  setState(() {
                    // reset Controller cho Map để lần tời khi load lại map
                    mapController = new MapController();
                  });
                  pageController.animateToPage(
                      TYPE, // Chuyển PageView tới trang thứ 2
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linearToEaseOut);
                },
                buttonTitle: "Confirm",
                textStyle: Constraint.Nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
