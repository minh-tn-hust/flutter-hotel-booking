import 'package:flutter/material.dart';
import 'package:hotel_booking_app/host/add_hotel/add_hotel.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/hotel_load_data/hotel_load_data.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/profile_screed.dart';
import 'package:hotel_booking_app/widgets/custom_bottom_naviagate_bar/bottom_navigate_bar.dart';
import 'package:provider/provider.dart';

class HostFrame extends StatefulWidget {
  const HostFrame({Key? key}) : super(key: key);

  @override
  _UserFrameState createState() => _UserFrameState();
}

class _UserFrameState extends State<HostFrame> {
  SearchInfoModel? searchInfo;
  PageController? pageViewController;
  int? index;
  @override
  void initState() {
    pageViewController = new PageController();
    super.initState();
    index = 0;
    searchInfo = new SearchInfoModel();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      AddHotel(),
      ProfileScreen(
          isHost: true,
          customerInfo: Provider.of<ApplicationState>(context).customerInfo),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageViewController,
                scrollDirection: Axis.horizontal,
                children: page,
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
              ),
            ),
            BottomNavigaBar(
              isHost: true,
              index: index!,
              pageView: (pos) async {
                await pageViewController?.animateToPage(
                  pos,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
