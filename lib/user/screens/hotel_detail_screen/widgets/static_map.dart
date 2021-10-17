import 'package:flutter/material.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_preview.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class StaticMap extends StatelessWidget {
  final LatLng location;
  const StaticMap({
    Key? key,
    required this.location,
  }) : super(key: key);
  String getStaticImageWithMarker(LatLng location) {
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/' +
        'geojson(%7B%22type%22%3A%22FeatureCollection%22%2C%22features%22%3A%5B%7B%22type%22%3A%22Feature%22%2C%22properties%22%3A%7B%22marker-color%22%3A%22%23462eff%22%2C%22marker-size%22%3A%22large%22%2C%22marker-symbol%22%3A%22warehouse%22%7D%2C%22geometry%22%3A%7B%22type%22%3A%22Point%22%2C%22coordinates%22%3A%5B${location.longitude}%2C${location.latitude}%5D%7D%7D%5D%7D%0A)/${location.longitude},${location.latitude},16/782x324?' +
        'access_token=pk.eyJ1IjoidnVkaW5ocGh1OTMzIiwiYSI6ImNrc2llZm9veDFqczgybm9mcDFsZmZoZjcifQ.5hbdu8RcE4144gVM-DaEXA';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(Uri.parse(getStaticImageWithMarker(location))),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ImagePreview(
            imagePaths: [getStaticImageWithMarker(location)],
            height: 162,
          );
        } else {
          return Container(
            height: 162,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
