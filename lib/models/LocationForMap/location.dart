import 'package:latlong2/latlong.dart';

class Location {
  String text;
  String place_name;
  LatLng coordinates;
  Location({
    required this.text,
    required this.place_name,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      text: json["text"],
      place_name: json["place_name"],
      coordinates: LatLng(json["longtitude"], json["latitude"]),
    );
  }
  factory Location.fromFirebaseJson(Map<String, dynamic> json) {
    return Location(
      text: json["text"],
      place_name: json["place_name"],
      coordinates: LatLng(
          json["coordinates"]["latitude"], json["coordinates"]["longtitude"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "place_name": place_name,
      "coordinates": {
        "longtitude": coordinates.longitude,
        "latitude": coordinates.latitude,
      },
    };
  }
}
