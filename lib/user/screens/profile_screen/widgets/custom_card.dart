import 'package:flutter/material.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/widgets/card_detect.dart';

import '../../../../constraint.dart';

class CustomCreditCard extends StatelessWidget {
  const CustomCreditCard({
    Key? key,
    required this.cardHolder,
    required this.cardNumber,
    required this.cardBrand,
  }) : super(key: key);
  final String cardNumber;
  final String cardHolder;
  final String cardBrand;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(8),
      // height: 220,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(7, 7),
            blurRadius: 0.7,
            spreadRadius: 0.2,
          ),
        ],
        color: Colors.black.withOpacity(0.8),
        // gradient: LinearGradient(
        //   colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        // ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65,
            child: Row(
              children: [
                // CustomButton(
                //     onTap: () {},
                //     buttonTitle: "Make default",
                //     textStyle: Constraint.Nunito(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //     height: 50),
                Spacer(),
                Container(
                  height: 65,
                  width: 100,
                  child: Image.asset(
                    "assets/images/stripe.png",
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Container(
                child: Text(
                  "•••• •••• •••• $cardNumber",
                  style: Constraint.Nunito(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Holder",
                      style: Constraint.Nunito(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      cardHolder,
                      style: Constraint.Nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DetectCardLogo(cardBrand: cardBrand),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
