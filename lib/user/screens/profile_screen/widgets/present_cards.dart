import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user/screens/profile_screen/widgets/custom_card.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/widgets/second_page/second_page.dart';
import 'package:provider/provider.dart';

class PresentCards extends StatelessWidget {
  const PresentCards({
    Key? key,
    required this.pageController,
    required this.viewportFraction,
    required this.pageOffset,
    required this.customerInfo,
    required this.callBack,
  }) : super(key: key);

  final PageController? pageController;
  final double viewportFraction;
  final double pageOffset;
  final CustomerInfo? customerInfo;
  final void Function() callBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // nếu như người dùng đã đăng nhập rồi thì sẽ hiển thị để người dùng có thể add card
         Container(
                height: 260,
                child: PageView.builder(
                    itemCount: customerInfo!.cards!.length + 1,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      double scale = max(viewportFraction,
                          (1 - (pageOffset - index).abs()) + viewportFraction);
                      double angle = (pageOffset - index).abs();
                      if (angle > 0.5) angle = 1 - angle;
                      if (index < customerInfo!.cards!.length) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: (50 - (scale * 25)),
                            left: 0,
                            right: 0,
                            bottom: 20,
                          ),
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: CustomCreditCard(
                                cardHolder: (customerInfo!.lastName! ==
                                        "No information")
                                    ? "No information"
                                    : (customerInfo!.lastName! +
                                        " " +
                                        customerInfo!.firstName!),
                                cardNumber:
                                    customerInfo!.cards![index].lastFour!,
                                cardBrand: customerInfo!.cards![index].brand!),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: (50 - (scale * 25)),
                            left: 0,
                            right: 0,
                            bottom: 20,
                          ),
                          child: InkWell(
                            highlightColor: Colors.blue,
                            splashColor: Colors.blue,
                            focusColor: Colors.blue,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SecondPage(
                                        customerInfo: customerInfo!,
                                        check: false,
                                        callBack: () {
                                          callBack();
                                        },
                                      )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF8A170),
                                    Color(0xFFFFCD61)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(7, 7),
                                    blurRadius: 0.7,
                                    spreadRadius: 0.2,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Add credit card",
                                    style: Constraint.Nunito(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ) ,
      ],
    );
  }
}
