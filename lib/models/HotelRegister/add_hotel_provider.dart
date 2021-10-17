import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:latlong2/latlong.dart';

class HotelProvider extends ChangeNotifier {
  late Hotel? addHotel;
  double? zoom;
  HotelProvider() {
    init();
  }
  void init() {
    this.addHotel = Hotel(
      imagePath: List.generate(5, (index) => ""),
      type: 1,
      amenities: [],
      rooms: [],
      location: Location(
        coordinates: LatLng(21, 105),
        place_name: 'This is default place in Hanoi',
        text: 'Hanoi',
      ),
    );
    zoom = 0;
  }

  void deleteRoomIndex(int index) {
    addHotel!.rooms!.removeAt(index);
    notifyListeners();
  }

  void updateRoomIndex(Room room, int index) {
    addHotel!.rooms![index] = room;
    notifyListeners();
  }

  void updateZoom(double zoom) {
    this.zoom = zoom;
    notifyListeners();
  }

  int? get type => addHotel!.type;
  void addRoom(Room room) {
    addHotel!.rooms!.add(room);
    notifyListeners();
  }

  void updateAmenities(String amenities, bool add) {
    if (add == true)
      addHotel!.amenities!.add(amenities);
    else
      addHotel!.amenities!.remove(amenities);
  }

  void updateImagePath(String imagePath, int index) {
    addHotel!.imagePath![index] = imagePath;
  }

  void updateRooms(List<Room> rooms) {
    addHotel!.rooms = rooms;
  }

  void updateLocation(Location location) {
    addHotel!.location = location;
  }

  void updateName(String name) {
    addHotel!.name = name;
  }

  void updatePrice(double lowestPrice, double highestPrice) {
    addHotel!.lowestPrice = lowestPrice;
    addHotel!.highestPrice = highestPrice;
  }

  void updateType(int type) {
    addHotel!.type = type;
    notifyListeners();
  }

  void updateLatLng(LatLng coordinates) {
    addHotel!.location!.coordinates = coordinates;
  }

  void updateDescription(String text) {
    addHotel!.description = text;
  }

  void createNewHotel() {
    addHotel = Hotel(
      imagePath: List.generate(5, (index) => ""),
      type: 1,
      amenities: [],
      rooms: [],
      location: Location(
        coordinates: LatLng(21, 105),
        place_name: 'This is default place in Hanoi',
        text: 'Hanoi',
      ),
    );
    zoom = 0;
  }

  /// include firebase
  Future<String> uploadImage(
      String path, String hostId, int index, String format) async {
    try {
      File file = File(path);
      var ref = await FirebaseStorage.instance
          .ref(
              '/image/${hostId + Timestamp.fromDate(DateTime.now()).toString()}')
          .putFile(file);
      var downloadUrl = await ref.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> uploadHotel(String hostId) async {
    addHotel!.hostID = hostId;
    // cập nhật image path cho hotel
    addHotel!.imagePath!.removeWhere((element) => (element == ""));

    for (int i = 0; i < addHotel!.imagePath!.length; i++) {
      addHotel!.imagePath![i] =
          await uploadImage(addHotel!.imagePath![i], hostId, i, "hotel");
    }

    // cập nhật image path cho room
    for (var room in addHotel!.rooms!) {
      room.imagePath!.removeWhere((element) => (element == ""));
      for (int i = 0; i < room.imagePath!.length; i++) {
        if (room.imagePath![i] != "") {
          room.imagePath![i] =
              await uploadImage(room.imagePath![i], hostId, i, "room");
        }
      }
    }

    addHotel!.lowestPrice = (addHotel!.rooms!.length != 0)
        ? addHotel!.rooms!.map((e) => e.price!).toList().reduce(min)
        : 0;
    addHotel!.highestPrice = (addHotel!.rooms!.length != 0)
        ? addHotel!.rooms!.map((e) => e.price!).toList().reduce(max)
        : 0;
    CollectionReference hotel =
        await FirebaseFirestore.instance.collection("hotelWithInfo");
    var host = await FirebaseFirestore.instance
        .collection("Host")
        .doc(addHotel!.hostID)
        .get();
    addHotel!.destination = (host.data() as Map<String, dynamic>)["accountId"]!;
    try {
      String? hotelID;
      await hotel.add(addHotel!.toJson()).then((value) {
        print("Value ${value.id}");
        hotelID = value.id;
      });
      if (addHotel!.rooms!.length != 0) {
        for (int i = 0; i < addHotel!.rooms!.length; i++) {
          addHotel!.rooms![i].id = hotelID! + i.toString();
        }
        await hotel.doc(hotelID).update(
            {"rooms": addHotel!.rooms!.map((e) => e.toJson()).toList()});
      }
    } on FirebaseException catch (e) {
      print("Exception ${e.message}");
    }
    ;
    return "Done";
  }
}
