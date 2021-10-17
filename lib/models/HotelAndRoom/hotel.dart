import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';

class Hotel {
  String? destination;
  String? payID;
  double? distance;
  bool? verify;
  String? hostID;
  String? hotelID;
  List<String>? imagePath;
  List<Room>? rooms;
  Location? location;
  String? name; // Tên
  double? lowestPrice;
  double? highestPrice;
  String? description;
  int? type; // 1 is hotel 0 is homestay
  List<String>? amenities;
  Hotel({
    this.destination,
    this.hostID,
    this.verify,
    this.imagePath,
    this.rooms,
    this.location,
    this.name,
    this.lowestPrice,
    this.highestPrice,
    this.type,
    this.amenities,
    this.description,
  });

  String toString() {
    return "${this.toJson()}";
  }

  Map<String, dynamic> toJson() {
    return {
      "payID": payID,
      "verity": verify,
      "hostID": hostID,
      "imagePath": imagePath,
      "rooms": List.generate(rooms!.length, (index) => rooms![index].toJson()),
      "location": location!.toJson(),
      "name": name,
      "lowestPrice": lowestPrice,
      "highestPrice": highestPrice,
      "description": description,
      "type": type,
      "amenities": amenities,
      "destination": destination,
    };
  }

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hostID: json["hostID"],
      destination: json["destination"],
      verify: json["verity"],
      name: json["name"],
      amenities: json["amenities"].map<String>((e) => e.toString()).toList(),
      highestPrice: json["highestPrice"].toDouble(),
      lowestPrice: json["lowestPrice"].toDouble(),
      location: Location.fromFirebaseJson(json["location"]),
      description: json["description"],
      rooms: json["rooms"].map<Room>((e) => Room.fromJson(e)).toList(),
      type: json["type"],
      imagePath: json["imagePath"]
          .map<String>((element) => element.toString())
          .toList(),
    );
  }

  void update(String field, dynamic content) {
    switch (field) {
      case "imagePath":
        this.imagePath = content;
        break;
      case "rooms":
        this.rooms = content;
        break;
      case "location":
        this.location = Location.fromFirebaseJson(content);
        break;
      case "name":
        this.name = content;
        break;
      case "amenities":
        this.amenities = content;
        break;
      case "description":
        this.description = content;
        break;
    }
  }

  void updateRoom(String field, dynamic content, int index) {
    print("hotel - updateRoom -=================");
    print(field);
    print(content);
    print(index);
    switch (field) {
      case "imagePath":
        this.rooms![index].imagePath = content;
        break;
      case "title":
        this.rooms![index].title = content;
        break;
      case "amenities":
        this.rooms![index].amenities = content;
        break;
      case "price":
        this.rooms![index].price = double.parse(content);
        break;
      case "recentAvailable":
        this.rooms![index].recentAvailable = int.parse(content);
        break;
    }
  }
}
