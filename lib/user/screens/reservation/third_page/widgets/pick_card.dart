import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/CustomerInfo/card_info.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/widgets/second_page/second_page.dart';

import '../../../../../constraint.dart';
import 'card_detect.dart';

class PickCard extends StatefulWidget {
  const PickCard({
    Key? key,
    required this.customerInfo,
    required this.callBack,
    required this.cardIndex,
  }) : super(key: key);
  final CustomerInfo customerInfo;
  final void Function(int index) callBack;
  final int cardIndex;

  @override
  _PickCardState createState() => _PickCardState();
}

class _PickCardState extends State<PickCard> {
  late int cardIndex;
  late CustomerInfo customerInfo;
  @override
  void initState() {
    cardIndex = widget.cardIndex;
    customerInfo = widget.customerInfo;
    super.initState();
  }

  void showListCard(BuildContext context, List<CardInfo> cards) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            height: min(120 * (cards.length + 1), 600),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: ListView.builder(
                itemCount: cards.length + 1,
                itemBuilder: (context, index) {
                  if (index == cards.length) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecondPage(
                                          customerInfo: customerInfo,
                                          check: false,
                                          callBack: () {
                                            widget.callBack(0);
                                            setState(() {});
                                          },
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.callBack(index);
                          setState(() {
                            cardIndex = index;
                          });
                          Navigator.of(context).pop();
                        },
                        child: CardRepresent(
                          customerInfo: widget.customerInfo,
                          cardIndex: index,
                          selected: (index == widget.cardIndex),
                        ),
                      ),
                    ],
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    customerInfo = widget.customerInfo;
    return GestureDetector(
      onTap: () {
        print("Clicking");
        showListCard(context, widget.customerInfo.cards!);
      },
      child: CardRepresent(
        customerInfo: widget.customerInfo,
        cardIndex: widget.cardIndex,
        selected: true,
      ),
    );
  }
}

class CardRepresent extends StatelessWidget {
  const CardRepresent({
    Key? key,
    required this.customerInfo,
    required this.cardIndex,
    required this.selected,
  }) : super(key: key);

  final CustomerInfo customerInfo;
  final int cardIndex;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Row(
          children: [
            DetectCardLogo(
              cardBrand: customerInfo.cards![cardIndex].brand!,
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "•••• •••• •••• ${customerInfo.cards![cardIndex].lastFour}",
                        style: Constraint.Nunito(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      if (selected)
                        Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                              child: Text(
                            " Selected ",
                            style: Constraint.Nunito(
                              fontSize: 16,
                              color: Colors.blue.shade900,
                            ),
                          )),
                        ),
                    ],
                  ),
                  Text(
                    (customerInfo.firstName! == "No information")
                        ? "No infomation"
                        : customerInfo.firstName! + customerInfo.lastName!,
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
