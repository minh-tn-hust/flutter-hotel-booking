import 'package:flutter/material.dart';

class DetectCardLogo extends StatelessWidget {
  final String cardBrand;
  DetectCardLogo({required this.cardBrand});

  @override
  Widget build(BuildContext context) {
    switch (cardBrand) {
      case "Visa":
        return Container(
          width: 65,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Image.asset(
            "assets/images/visacard.png",
            fit: BoxFit.cover,
          ),
        );
      case "MasterCard":
        return Container(
          width: 65,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Image.asset(
            "assets/images/mastercard.png",
            fit: BoxFit.cover,
          ),
        );
      case "American Express":
        return Container(
          width: 65,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Image.asset(
            "assets/images/amex.png",
            fit: BoxFit.cover,
          ),
        );
      case "Discover":
        return Container(
          width: 65,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Image.asset(
            "assets/images/discover.png",
            fit: BoxFit.cover,
          ),
        );
      default:
        return Container(
          height: 100,
          width: 100,
          color: Colors.red,
        );
    }
  }
}
