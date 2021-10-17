import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:hotel_booking_app/widgets/home_search_room/pick_location/auto_complete_search.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class GetHotelLocation extends StatefulWidget {
  const GetHotelLocation({
    Key? key,
    required this.mapController,
    required this.location,
  }) : super(key: key);
  final MapController
      mapController; // sử dụng để có thể lấy thông tin hiện tại của map
  final Location?
      location; // biến nhận từ Provider, để có thể biết và hiển thị được vị trí người ta đã chọn
  @override
  GetHotelLocationState createState() => GetHotelLocationState();
}

class GetHotelLocationState extends State<GetHotelLocation> {
  Location? pickedItem; // biển sử dụng để lưu được vị trí mà người dùng đã chọn
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _mapController = widget.mapController;
    return Container(
      height: 650,
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Where do you live?", // Phần câu hỏi
              style: Constraint.Nunito(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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
                      mapController: _mapController,
                      options: MapOptions(
                        // nếu như location được gửi vào từ widget cha
                        //là mới hoàn toàn thì map sẽ được cố định vị trí tại đây
                        center: (widget.location == null)
                            ? LatLng(21.5, 105.6)
                            : widget.location!.coordinates,

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
                        Provider.of<HotelProvider>(context, listen: false)
                            .updateLocation(
                                location); // cập nhật lại vị trí mà người dùng đã chọn lên Provider
                        setState(() {
                          pickedItem = location; // set lại vị trí location
                          _mapController.move(pickedItem!.coordinates,
                              13); // di chuyển map tới vị trí mà người dùng đã chọn
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
        ],
      ),
    );
  }
}
