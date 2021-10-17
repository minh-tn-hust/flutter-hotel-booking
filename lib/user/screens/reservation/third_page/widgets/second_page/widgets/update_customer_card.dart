import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../../../../../../constraint.dart';

class UpdateCustomerCard extends StatelessWidget {
  const UpdateCustomerCard({
    Key? key,
    required this.creditCard,
    required this.callBack,
    required this.future,
  }) : super(key: key);
  final CreditCard creditCard;
  final void Function() callBack;
  final Future<Map<String, String>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AlertDialog(
            title: Text(
              "Waiting",
              style: Constraint.Nunito(),
            ),
            content: Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        print(
            "update_customer_card - line 39 - snapshot.data = ${snapshot.data}");
        if (snapshot.hasError) {
          return AlertDialog(
              title: Text(
                "Error",
                style: Constraint.Nunito(),
              ),
              content: Text(
                snapshot.error.toString(),
                style: Constraint.Nunito(),
              ),
              actions: [
                CustomButton(
                  onTap: () {
                    callBack();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  buttonTitle: "Confirm",
                  textStyle: Constraint.Nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 50,
                )
              ]);
        }
        if (snapshot.data!["Done"] == "Done")
          return AlertDialog(
              title: Text(
                "Success",
                style: Constraint.Nunito(),
              ),
              content: Text(
                "Adding successed",
                style: Constraint.Nunito(),
              ),
              actions: [
                CustomButton(
                  onTap: () {
                    callBack();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  buttonTitle: "Confirm",
                  textStyle: Constraint.Nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 50,
                )
              ]);
        return AlertDialog(
            title: Text(
              "Fail",
              style: Constraint.Nunito(),
            ),
            content: Text(
              snapshot.data["Error"],
              style: Constraint.Nunito(),
            ),
            actions: [
              CustomButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                buttonTitle: "Confirm",
                textStyle: Constraint.Nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                height: 50,
              )
            ]);
      },
    );
  }
}
