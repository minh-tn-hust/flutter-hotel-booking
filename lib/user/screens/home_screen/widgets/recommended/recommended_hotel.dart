import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/hotel_detail_screen.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';

class RecommendedHotel extends StatelessWidget {
  const RecommendedHotel({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailScreen(
              hotel: hotel,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15, bottom: 20),
            width: 265,
            height: 185,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0),
                  Color.fromRGBO(0, 0, 0, 0.3),
                  Color.fromRGBO(0, 0, 0, 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.5, 1],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomCacheImage(
                height: 185,
                url: hotel.imagePath![0],
                width: 265,
              ),
            ),
          ),
          //text inside border
          Positioned(
            top: 117,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${hotel.name}",
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        (hotel.location!.text.length > 15)
                            ? '${hotel.location!.text.substring(0, 15)}...'
                            : '${hotel.location!.text}',
                        style: Constraint.Nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "${num.parse(hotel.lowestPrice!.toStringAsFixed(0))} \$",
                        style: Constraint.Nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
