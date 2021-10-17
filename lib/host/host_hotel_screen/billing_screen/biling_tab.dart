import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/PaymentIntent/payment_intent.dart';
import 'package:intl/intl.dart';

class BillingTab extends StatelessWidget {
  const BillingTab({Key? key, required this.payment}) : super(key: key);
  final PaymentIntent payment;
  Color checkColor(String status) {
    switch (status) {
      case "cancel":
        return Colors.grey;
      case "refund":
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat("yyyy-MM-dd – kk:mm")
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          payment.create! * 1000))
                      .toString(),
                  style: Constraint.Nunito(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                payment.status!.toUpperCase(),
                style: Constraint.Nunito(
                  fontSize: 16,
                  color: checkColor(payment.status!),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Type: ",
                        style: Constraint.Nunito(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        payment.roomName!,
                        style: Constraint.Nunito(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "From: ",
                          style: Constraint.Nunito(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: DateFormat.MMMEd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  payment.beginDate! * 1000)),
                          style: Constraint.Nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " to ",
                          style: Constraint.Nunito(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: DateFormat.MMMEd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  payment.endDate! * 1000)),
                          style: Constraint.Nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    "${payment.amount! / 100}\$",
                    style: Constraint.Nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: checkColor(payment.status!),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
