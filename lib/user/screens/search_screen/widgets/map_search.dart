import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/hotel_detail_screen.dart';
import 'package:latlong2/latlong.dart';

class MapSearch extends StatelessWidget {
  const MapSearch({
    Key? key,
    required this.mapController,
    required this.initLocation,
    required this.children,
    required this.callBack,
  }) : super(key: key);

  final LatLng initLocation;
  final MapController mapController;
  final List<Hotel> children;
  final void Function() callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: initLocation,
          minZoom: 7,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/vudinhphu933/cksielcvb5ogn17ocglkuacgf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidnVkaW5ocGh1OTMzIiwiYSI6ImNrc2llZm9veDFqczgybm9mcDFsZmZoZjcifQ.5hbdu8RcE4144gVM-DaEXA",
            additionalOptions: {'id': 'mapbox.streets'},
          ),
          MarkerLayerOptions(
            markers: List.generate(
              children.length + 1,
              (index) {
                if (index < children.length)
                  return CustomMarker(context, children[index]);
                else
                  return Marker(
                      point: initLocation,
                      builder: (context) => Icon(
                            Icons.location_on,
                            size: 42,
                            color: Colors.blueAccent[700],
                          ));
              },
            ),
            // get request to server to get Hotel infomation
          ),
        ],
      ),
    );
  }

  Marker CustomMarker(BuildContext context, Hotel hotel) {
    return Marker(
      width: 70,
      height: 25,
      point: hotel.location!.coordinates,
      builder: (ctx) => GestureDetector(
        onTap: () {
          mapController.move(hotel.location!.coordinates, 13);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return HotelDetailScreen(hotel: hotel);
          }));
        },
        child: Container(
          padding: EdgeInsets.only(
            left: 3,
            right: 3,
          ),
          height: 25,
          decoration: BoxDecoration(
            color: (hotel.type == 0) ? Colors.orange : Colors.purple,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "${(hotel.lowestPrice!).toStringAsFixed(2)}\$",
              style: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
