// import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/admin/admin_frame.dart';
import 'package:hotel_booking_app/models/HotelRegister/add_hotel_provider.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

import 'models/HotelAndRoom/hotel.dart';
import 'models/HotelAndRoom/hotel_room.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Future<FirebaseApp> initFirebaseForEmulator() async {
    var getAppInstance = await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(
      host: "10.0.2.2:8080",
      sslEnabled: false,
      persistenceEnabled: false,
    );
    FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
    FirebaseStorage.instance.useStorageEmulator("10.0.2.2", 9199);
    return getAppInstance;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp?>(
      future: initFirebaseForEmulator(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return ApplicationState();
                },
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return HotelProvider();
                },
              ),
              ChangeNotifierProvider(
                create: (context) => SearchModel(),
              ),
              ChangeNotifierProvider(
                create: (context) => SelectedHotel(),
              ),
            ],
            child: MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: Consumer<ApplicationState>(
                  builder: (context, state, _) {
                    print("Main - Consumer - Called");
                    print(state.hashCode);
                    return LoginScreen(state: state);
                  },
                )
                // home: AdminFrame(),
                ),
          );
        return MaterialApp(
          home: Container(),
        );
      },
    );
  }
}

class SelectedHotel extends ChangeNotifier {
  Hotel? selectedHotel;
  SelectedHotel({this.selectedHotel});

  void changeHotel(Hotel hotel) {
    if (selectedHotel == null) {
      this.selectedHotel = hotel;
      notifyListeners();
    } else {
      if (selectedHotel!.hotelID != hotel.hotelID) {
        this.selectedHotel = hotel;
        notifyListeners();
      }
    }
  }

  Future<void> updateMessage() async {
    await FirebaseFirestore.instance // tạo notification cho host
        .collection("hotelNotifi")
        .add({
      "hostId": selectedHotel!.hostID,
      "hotelId": selectedHotel!.hotelID,
      "message": "Your hotel was updated, we change to pending to check again",
      "status": "Pending",
      "read": false,
      "created": Timestamp.fromDate(DateTime.now()).seconds,
    });
  }

  Future<String> addRoom(Room room) async {
    room.id = selectedHotel!.hotelID.toString() +
        selectedHotel!.rooms!.length.toString();
    print(room.id);
    List<String> imagePath = [];
    print(room.toJson());
    // upload ảnh của room lên firebase
    for (int i = 0; i < room.imagePath!.length; i++) {
      if (room.imagePath![i] != "") {
        var status =
            await uploadImage(room.imagePath![i], selectedHotel!.hostID!);
        if (!status.contains("http"))
          return status;
        else
          imagePath.add(status);
      }
    }
    room.imagePath = imagePath;
    List<Map<String, dynamic>> rooms = [];
    var lowestPrice = selectedHotel!.lowestPrice;
    var highestPrice = selectedHotel!.highestPrice;
    for (int i = 0; i < selectedHotel!.rooms!.length; i++) {
      rooms.add(selectedHotel!.rooms![i].toJson());
      if (lowestPrice! > selectedHotel!.rooms![i].price!) {
        lowestPrice = selectedHotel!.rooms![i].price;
      }
      if (highestPrice! < selectedHotel!.rooms![i].price!) {
        highestPrice = selectedHotel!.rooms![i].price;
      }
    }
    rooms.add(room.toJson());
    for (int i = 0; i < rooms.length; i++) {
      if (lowestPrice! > rooms[i]["price"]) {
        lowestPrice = rooms[i]["price"];
      }
      if (highestPrice! < rooms[i]["price"]) {
        highestPrice = rooms[i]["price"];
      }
    }

    print(rooms);
    print(lowestPrice);
    print(highestPrice);
    try {
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update(
        {
          "rooms": rooms,
          "lowestPrice": lowestPrice,
          "highestPrice": highestPrice,
          "verity": null,
        },
      );
      selectedHotel!
          .update("rooms", rooms.map((e) => Room.fromJson(e)).toList());
      print(selectedHotel!.rooms!.length);
      selectedHotel!.lowestPrice = lowestPrice;
      selectedHotel!.highestPrice = highestPrice;
      if (selectedHotel!.verify != null) updateMessage();
      selectedHotel!.verify = null;
      notifyListeners();
      return "Done";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> uploadImage(
    String path,
    String hostId,
  ) async {
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

  Future<String> updateRoomImage(List<String> imagePath, int index) async {
    for (int i = 0; i < imagePath.length; i++) {
      if (!imagePath[i].contains("http")) {
        print("updateImagePath - imagePath[i]: ${imagePath[i]}");
        var status = await uploadImage(
          imagePath[i],
          selectedHotel!.hostID!,
        );
        if (status.contains("http")) {
          imagePath[i] = status;
        } else {
          return status;
        }
      }
    }

    List<Map<String, dynamic>> rooms = [];
    try {
      for (int i = 0; i < selectedHotel!.rooms!.length; i++) {
        if (i == index) {
          Room newUpdate = selectedHotel!.rooms![i];
          newUpdate.imagePath = imagePath;
          rooms.add(newUpdate.toJson());
        } else {
          rooms.add(selectedHotel!.rooms![i].toJson());
        }
      }
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({"rooms": rooms, "verity": null});
      if (selectedHotel!.verify != null) updateMessage();
      selectedHotel!.verify = null;
      selectedHotel!.updateRoom("imagePath", imagePath, index);
      notifyListeners();
      return "Done";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateImagePath(List<String> imagePath) async {
    for (int i = 0; i < imagePath.length; i++) {
      if (!imagePath[i].contains("http")) {
        print("updateImagePath - imagePath[i]: ${imagePath[i]}");
        var status = await uploadImage(
          imagePath[i],
          selectedHotel!.hostID!,
        );
        if (status.contains("http")) {
          imagePath[i] = status;
        } else {
          return status;
        }
      }
    }
    try {
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({"imagePath": imagePath, "verity": null});
      selectedHotel!.update("imagePath", imagePath);
      selectedHotel!.verify = null;
      notifyListeners();
      return "Done";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateRoomInfo(
      String field, dynamic content, int index) async {
    print(
        "*******************upadteRoomInfo call index = $index \n content = $content \n field = $field");
    try {
      List<Map<String, dynamic>> rooms = [];
      for (int i = 0; i < selectedHotel!.rooms!.length; i++) {
        if (i == index) {
          Room newUpdate = selectedHotel!.rooms![i];
          switch (field) {
            case "imagePath":
              newUpdate.imagePath = content;
              break;
            case "title":
              newUpdate.title = content;
              break;
            case "amenities":
              newUpdate.amenities = content;
              break;
            case "price":
              newUpdate.price = double.parse(content);
              break;
            case "recentAvailable":
              newUpdate.recentAvailable = int.parse(content);
              break;
          }
          rooms.add(newUpdate.toJson());
        } else {
          rooms.add(selectedHotel!.rooms![i].toJson());
        }
      }
      var lowestPrice;
      var highestPrice;
      if (rooms.length == 0) {
        lowestPrice = 0;
        highestPrice = 0;
      } else {
        lowestPrice = rooms[0]["price"];
        highestPrice = rooms[0]["price"];
        for (int i = 0; i < rooms.length; i++) {
          if (lowestPrice > rooms[i]["price"]) lowestPrice = rooms[i]["price"];
          if (highestPrice < rooms[i]["price"])
            highestPrice = rooms[i]["price"];
        }
      }

      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({
        "rooms": rooms,
        "lowestPrice": lowestPrice,
        "highestPrice": highestPrice,
        "verity": null,
      });
      selectedHotel!.updateRoom(field, content, index);
      selectedHotel!.highestPrice = highestPrice;
      selectedHotel!.lowestPrice = lowestPrice;
      if (selectedHotel!.verify != null) updateMessage();
      selectedHotel!.verify = null;
      notifyListeners();
      return "Done";
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  Future<String> deleteRoom(int index) async {
    List<Map<String, dynamic>> rooms = [];
    for (int i = 0; i < selectedHotel!.rooms!.length; i++) {
      if (i != index) rooms.add(selectedHotel!.rooms![i].toJson());
    }
    var lowestPrice;
    var highestPrice;
    if (rooms.length == 0) {
      lowestPrice = 0;
      highestPrice = 0;
    } else {
      lowestPrice = rooms[0]["price"];
      highestPrice = rooms[0]["price"];
      for (int i = 0; i < rooms.length; i++) {
        if (lowestPrice > rooms[i]["price"]) lowestPrice = rooms[i]["price"];
        if (highestPrice < rooms[i]["price"]) highestPrice = rooms[i]["price"];
      }
    }
    try {
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({
        "rooms": rooms,
        "lowestPrice": lowestPrice,
        "highestPrice": highestPrice,
        "verity": null,
      });
      selectedHotel!
          .update("rooms", rooms.map((e) => Room.fromJson(e)).toList());
      selectedHotel!.highestPrice = highestPrice;
      selectedHotel!.lowestPrice = lowestPrice;
      if (selectedHotel!.verify != null) updateMessage();
      selectedHotel!.verify = null;
      print(highestPrice);
      print(lowestPrice);
      notifyListeners();
      return "Done";
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  Future<String> deleteHotel() async {
    try {
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({"hostID": null, "verity": false});
      notifyListeners();
      return "Done";
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }

  Future<String> updateInfo(String field, dynamic content) async {
    // firebase update
    try {
      await FirebaseFirestore.instance
          .collection("hotelWithInfo")
          .doc(selectedHotel!.hotelID)
          .update({field: content, "verity": null});
      selectedHotel!.update(field, content);
      if (selectedHotel!.verify != null) updateMessage();
      selectedHotel!.verify = null;
      notifyListeners();
      return "Done";
    } on FirebaseException catch (e) {
      return e.message!;
    }
  }
}
