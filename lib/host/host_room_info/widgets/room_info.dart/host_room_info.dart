import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/host/add_hotel/add_room/get_room_info/get_room_info.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/room_info.dart/widgets/room_card.dart';
import 'package:hotel_booking_app/host/host_room_info/widgets/room_info.dart/widgets/room_detail.dart';
import 'package:hotel_booking_app/main.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

class HostRoomInfo extends StatefulWidget {
  const HostRoomInfo({Key? key, required this.callBack}) : super(key: key);
  final void Function() callBack;

  @override
  _HostRoomInfoState createState() => _HostRoomInfoState();
}

class _HostRoomInfoState extends State<HostRoomInfo> {
  List<String> roomNames = [];
  List<int> index = [];
  late List<Room> rooms;
  int value = 0;
  late int ADDNEWROOM;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rooms = Provider.of<SelectedHotel>(context).selectedHotel!.rooms!;
    List<String> title = [];
    List<dynamic> content = [];
    roomNames.clear();
    index.clear();
    for (int i = 0; i < rooms.length; i++) {
      roomNames.add(rooms[i].title!);
      index.add(i);
    }
    ADDNEWROOM = rooms.length;
    roomNames.add("New room");
    index.add(ADDNEWROOM);
    if (value != ADDNEWROOM)
      rooms[value].toJson().keys.forEach((element) {
        if (element != "id") {
          title.add(element);
          content.add(rooms[value].toJson()[element]);
        }
      });
    print("INDEX LENGTH: ${index.length}");
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButton<int>(
              value: value,
              underline: SizedBox(),
              onChanged: (value) {
                if (value != ADDNEWROOM)
                  setState(() {
                    this.value = value!;
                  });
                else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GetRoomInfo(
                      isEdit: true,
                      room: new Room(
                        imagePath: List.generate(5, (index) => ""),
                        amenities: [],
                      ),
                      index: -1,
                      callBack: () {
                        setState(() {});
                        widget.callBack();
                      },
                    ),
                  ));
                }
              },
              selectedItemBuilder: (context) {
                return index
                    .map(
                      (e) => Container(
                        width: 300,
                        child: Align(
                          child: Text(
                            roomNames[e],
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    )
                    .toList();
              },
              items: index.map((e) {
                if (e == rooms.length) {
                  return DropdownMenuItem(
                      child: Container(
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 40,
                              ),
                              Text(
                                "Add a new room",
                                style: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      value: e);
                }
                return DropdownMenuItem(
                  child: RoomCard(
                    text: roomNames[e],
                    imageUrl: (rooms[e].imagePath!.length != 0)
                        ? rooms[e].imagePath![0]
                        : "https://images.unsplash.com/photo-1590074072786-a66914d668f1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=80",
                  ),
                  value: e,
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: List.generate(title.length + 1, (index) {
                if (index == title.length) {
                  return Column(
                    children: [
                      CustomButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    CustomButton(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FutureBuilder(
                                                  future: Provider.of<
                                                              SelectedHotel>(
                                                          context,
                                                          listen: false)
                                                      .deleteRoom(value),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.data ==
                                                        "Done") {
                                                      return AlertDialog(
                                                        actions: [
                                                          CustomButton(
                                                            onTap: () {
                                                              widget.callBack();
                                                              setState(() {
                                                                value = 0;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            buttonTitle:
                                                                "Confirm",
                                                            textStyle:
                                                                Constraint
                                                                    .Nunito(
                                                              fontSize: 14,
                                                            ),
                                                            height: 30,
                                                          ),
                                                        ],
                                                        title: Text(
                                                          "Done",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                        content: Text(
                                                          "Your room has been deleted",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                      );
                                                    } else {
                                                      return AlertDialog(
                                                        actions: [
                                                          CustomButton(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            buttonTitle:
                                                                "Confirm",
                                                            textStyle:
                                                                Constraint
                                                                    .Nunito(
                                                              fontSize: 14,
                                                            ),
                                                            height: 30,
                                                          ),
                                                        ],
                                                        title: Text(
                                                          "Error",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                        content: Text(
                                                          "${snapshot.data}",
                                                          style: Constraint
                                                              .Nunito(),
                                                        ),
                                                      );
                                                    }
                                                  });
                                            });
                                      },
                                      buttonTitle: "Confirm",
                                      textStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      height: 30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      buttonTitle: "Cancel",
                                      textStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      height: 30,
                                    ),
                                  ],
                                  title: Text(
                                    "Warning",
                                    style: Constraint.Nunito(),
                                  ),
                                  content: Text(
                                    "After you delete this, you can restore, are you sure?",
                                    style: Constraint.Nunito(),
                                  ),
                                );
                              });
                        },
                        buttonTitle: "Delete this room",
                        textStyle: Constraint.Nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        height: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    RoomDetail(
                      title: title[index],
                      roomIndex: value,
                      content: content[index],
                    ),
                    Container(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1.5,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          // if (value == rooms.length)
          //   Expanded(
          //     child: GetRoomInfo(
          //       room: new Room(
          //         imagePath: List.generate(5, (index) => ""),
          //         amenities: [],
          //       ),
          //       index: -1,
          //       callBack: () {
          //         setState(() {});
          //       },
          //     ),
          //   )
        ],
      ),
    );
  }
}
