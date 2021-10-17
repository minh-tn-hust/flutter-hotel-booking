import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/SearchInformation/search_info_model.dart';
import 'package:hotel_booking_app/user/screens/home_screen/widgets/recommended/recommended_hotel.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

class Recommended extends StatefulWidget {
  const Recommended({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Hotel> children;

  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  FirebaseService service = new FirebaseService();
  @override
  Widget build(BuildContext context) {
    var searchModel = Provider.of<SearchModel>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 35, left: 21, right: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended",
              style: Constraint.Nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              height: 185,
              child: FutureBuilder<List<Hotel>>(
                  future: service.loadRecommendHotel(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 15, bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 185,
                            width: 265,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print("snapshot ${snapshot.error}");
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Something wrong in process!",
                                style: Constraint.Nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text("Refresh")),
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.data!.length != 0)
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return RecommendedHotel(
                            hotel: snapshot.data![index],
                          );
                        },
                      );
                    else
                      return Center(
                        child: Text(
                          "No recommended hotel",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
