import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';

import '../../../../constraint.dart';

class HeaderInformation extends StatelessWidget {
  const HeaderInformation({
    Key? key,
    required this.customerInfo,
  }) : super(key: key);

  final CustomerInfo? customerInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (customerInfo == null)
                        ? "Guest"
                        : "${customerInfo!.firstName}",
                    style: Constraint.Nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (customerInfo != null)
                    Text(
                      "${customerInfo!.lastName}",
                      style: Constraint.Nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Spacer(),
              if(customerInfo != null)CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/card_background.jpg"),
                child: Text(
                  "${customerInfo!.firstName![0].toUpperCase()}${customerInfo!.lastName![0].toUpperCase()}",
                  style: Constraint.Nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                maxRadius: 25,
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
