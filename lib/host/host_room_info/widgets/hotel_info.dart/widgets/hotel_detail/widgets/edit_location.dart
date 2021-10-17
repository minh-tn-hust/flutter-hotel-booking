import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/home_search_room/pick_location/auto_complete_search.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class EditLocation extends StatefulWidget {
  const EditLocation({
    Key? key,
    required this.content,
  }) : super(key: key);
  final dynamic content;

  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  Location? location;
  MapController mapController = new MapController();
  @override
  void initState() {
    // TODO: implement initState
    location =
        Location.fromFirebaseJson(widget.content as Map<String, dynamic>);
    super.initState();
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
        height: 729,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      FlutterMap(
                        // hiển thị map để có thể cho người dùng
                        //tùy chọn kéo thả vị trí mong muốn
                        mapController: mapController,
                        options: MapOptions(
                          // nếu như location được gửi vào từ widget cha
                          //là mới hoàn toàn thì map sẽ được cố định vị trí tại đây
                          center: (location == null)
                              ? LatLng(21.5, 105.6)
                              : location!.coordinates,

                          zoom: 13,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://api.mapbox.com/styles/v1/thienhauocmo/ckqnl3it73cun19lchw1zoufh/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhpZW5oYXVvY21vIiwiYSI6ImNrcTlyY2prbjBiYzgyd282a3YwbnBqNW4ifQ.EIBldMD4MZqnKLIHG5SkVw",
                            additionalOptions: {
                              'accessToken':
                                  'pk.eyJ1IjoidGhpZW5oYXVvY21vIiwiYSI6ImNrcTlyY2prbjBiYzgyd282a3YwbnBqNW4ifQ.EIBldMD4MZqnKLIHG5SkVw',
                              'id': 'mapbox.streets'
                            },
                          ),
                        ],
                      ),
                      AutoCompleteSearch(
                        // thanh autocomplete hỗ trợ người dùng trong việt tìm kiếm
                        //vị trí trên bản đồ
                        pickItem: (location) {
                          mapController.move(location.coordinates, 13);
                          setState(() {
                            this.location = location;
                          });
                        },
                      ),
                      Center(
                        // Marker -> để cho người dùng viết được
                        // vị trí mình muốn đánh dấu nằm ở đâu
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                      print(mapController.center.latitude);
                      print(location!.text);
                      setState(() {
                        this.location!.coordinates = mapController.center;
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmInfo(location: location!);
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

class ConfirmInfo extends StatefulWidget {
  const ConfirmInfo({
    Key? key,
    required this.location,
  }) : super(key: key);
  final Location location;

  @override
  _ConfirmInfoState createState() => _ConfirmInfoState();
}

class _ConfirmInfoState extends State<ConfirmInfo> {
  late TextEditingController fullAddress;
  late TextEditingController shortAddress;
  late TextEditingController areaController;
  @override
  void initState() {
    // TODO: implement initState
    fullAddress = TextEditingController(text: widget.location.place_name);
    shortAddress = TextEditingController(text: widget.location.text);
    areaController = TextEditingController(text: "Viet Nam");
    super.initState();
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
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 325,
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
                        Location location = widget.location;
                        location.text = shortAddress.text;
                        location.place_name = fullAddress.text;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FutureBuilder(
                                  future: Provider.of<SelectedHotel>(context,
                                          listen: false)
                                      .updateInfo(
                                          "location", location.toJson()),
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
          ],
        ),
      ),
    );
  }
}
