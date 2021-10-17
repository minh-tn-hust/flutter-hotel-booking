import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/home_screen/homescreen.dart';
import 'package:hotel_booking_app/user/screens/notifcation_screen/history_screen.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/profile_screed.dart';
import 'package:hotel_booking_app/user/screens/search_screen/search_screen.dart';
import 'package:hotel_booking_app/widgets/custom_bottom_naviagate_bar/bottom_navigate_bar.dart';
import 'package:provider/provider.dart';

class UserFrame extends StatefulWidget {
  const UserFrame({Key? key}) : super(key: key);

  @override
  _UserFrameState createState() => _UserFrameState();
}

class _UserFrameState extends State<UserFrame> {
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
      // HomeScreen(),
      HomeScreen(
        callBack: () {
          setState(() {
            index = 1;
            pageViewController!.animateToPage(1,
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
          });
        },
      ),
      SearchScreen(searchModel: context.watch<SearchModel>().searchState!),
      HistoryScreen(),
      ProfileScreen(
        customerInfo: context.read<ApplicationState>().customerInfo,
      ),
    ];
    return Scaffold(
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
              index: index!,
              pageView: (pos) async {
                await pageViewController?.animateToPage(
                  pos,
                  duration: Duration(milliseconds: 300),
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
