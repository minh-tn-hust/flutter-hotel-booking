import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:provider/provider.dart';

class HotelLoadData extends StatefulWidget {
  const HotelLoadData({Key? key}) : super(key: key);

  @override
  _HotelLoadDataState createState() => _HotelLoadDataState();
}

class _HotelLoadDataState extends State<HotelLoadData> {
  @override
  Widget build(BuildContext context) {
    ApplicationState state = Provider.of<ApplicationState>(context);
    var fbService = FirebaseService();
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<Hotel>>(
            future: fbService.loadHotelWithUId(state.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  height: 100,
                  width: 250,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      Text("Has unknown error, please try a gain"),
                );
                return Container();
              } else
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Container(
                    child: Text(snapshot.data![index].name!),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}
