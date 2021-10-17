import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart' as Model;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class SearchInfoModel {
  int? guests;
  double? maxDistance;
  double? maxPrice;
  double? minPrice;
  int? type;
  int? nights;
  DateTime? beginDate;
  DateTime? endDate;
  Model.Location? location;
  int? roomAmount;
  SearchInfoModel(
      {this.guests,
      this.roomAmount,
      this.nights,
      this.beginDate,
      this.endDate,
      this.location,
      this.maxDistance,
      this.maxPrice,
      this.minPrice,
      this.type});
}

class SearchModel extends ChangeNotifier {
  SearchInfoModel? searchState;
  Hotel? pickHotel;
  Room? pickRoom;
  int? roomAvailable;
  SearchModel() {
    init();
  }
  Future<void> init() async {
    searchState = new SearchInfoModel(
      roomAmount: 1,
      maxDistance: 10,
      maxPrice: 1000,
      minPrice: 0,
      type: 2,
      beginDate: null,
      endDate: null,
      nights: null,
      guests: null,
      location: Model.Location(
        text: "Place",
        place_name: "Place",
        coordinates: LatLng(10.798454161528245, 106.69393169634549),
      ),
    );
  }

  LatLng get location => searchState!.location!.coordinates;
  void addDistance(double distance) {
    searchState!.maxDistance = distance;
    notifyListeners();
  }

  void updateRoomAvailable(int colusion) {
    this.roomAvailable = pickRoom!.recentAvailable! - colusion;
  }

  void updateRoomType(Room roomType) {
    this.searchState!.roomAmount = 1;
    this.pickRoom = roomType;
    print("Update room type: " + "$roomType");
  }

  void updateRoomAmount(int roomAmount) {
    this.searchState!.roomAmount = roomAmount;
  }

  void updateHotel(Hotel hotel) {
    this.pickHotel = hotel;
    print("this is " + "${hotel.hotelID}");
  }

  void addMaxPrice(double maxPrice) {
    searchState!.maxPrice = maxPrice;

    notifyListeners();
  }

  void addMinPrice(double minPrice) {
    searchState!.minPrice = minPrice;
    notifyListeners();
  }

  void addType(int type) {
    searchState!.type = type;
    notifyListeners();
  }

  void updateTime(DateTime begin, DateTime end) {
    searchState!.beginDate = begin;
    searchState!.endDate = end;
    notifyListeners();
  }

  void updateLocation(Model.Location? location) {
    searchState!.location = location;
    notifyListeners();
  }

  void updateNight(int nights) {
    searchState!.nights = nights;
    notifyListeners();
  }

  void updateGuests(int guests) {
    searchState!.guests = guests;
    notifyListeners();
  }

  @override
  String toString() {
    print("${searchState!.beginDate}");
    print("${searchState!.endDate}");
    print("${searchState!.guests}");
    print("${searchState!.nights}");
    print("${searchState!.location!.place_name}");
    return "";
    notifyListeners();
  }
}
