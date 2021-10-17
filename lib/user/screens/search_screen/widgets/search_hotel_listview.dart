import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/hotel_detail_screen.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';
import 'package:hotel_booking_app/widgets/star_rate/star_rate.dart';

class SearchHotelListView extends StatefulWidget {
  const SearchHotelListView({
    Key? key,
    required this.mapController,
    required this.children,
  }) : super(key: key);

  final MapController mapController;
  final List<Hotel> children;

  @override
  _SearchHotelListViewState createState() => _SearchHotelListViewState();
}

class _SearchHotelListViewState extends State<SearchHotelListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(248, 161, 112, 0),
            Color.fromRGBO(255, 205, 97, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
        ),
      ),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.mapController
                  .move(widget.children[index].location!.coordinates, 16);
            },
            onDoubleTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      HotelDetailScreen(hotel: widget.children[index]),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: 200,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0),
                            Color.fromRGBO(0, 0, 0, 0.5)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.4, 1],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: CustomCacheImage(
                            url: '${widget.children[index].imagePath![0]}',
                            height: 100,
                            width: 200,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange,
                      ),
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      child: Text(
                        "from ${widget.children[index].lowestPrice!}\$",
                        style: Constraint.Nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 12,
                      child: Text(
                        "${widget.children[index].name}",
                        style: Constraint.Nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
