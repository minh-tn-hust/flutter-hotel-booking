import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/host_hotel_screen/billing_screen/billing_screen.dart';
import 'package:hotel_booking_app/host/host_room_info/host_hotel_room.dart';

class HostHotelScreen extends StatefulWidget {
  const HostHotelScreen({Key? key, required this.callBack}) : super(key: key);
  final void Function() callBack;

  @override
  _HostHotelScreenState createState() => _HostHotelScreenState();
}

class _HostHotelScreenState extends State<HostHotelScreen> {
  late List<Widget> hotelScreen;
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    hotelScreen = [
      BillingScreen(),
      HostHotelRoom(callBack: () {
        widget.callBack(); // setState tại trang chủ khi xóa một khách sạn
      }),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Host Hotel  Screen call");
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: Colors.orangeAccent,
          backgroundColor: Colors.grey.shade200,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "Analysis",
            ),
            BottomNavigationBarItem(
              label: "Information",
              icon: Icon(Icons.analytics),
            ),
          ],
        ),
        body: SafeArea(
          child: hotelScreen[currentIndex],
        ),
      ),
    );
  }
}
