import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';

class HostAddBar extends StatelessWidget {
  final void Function() nextCallBack;
  final void Function() backCallBack;
  const HostAddBar({
    Key? key,
    required this.nextCallBack,
    required this.backCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(
          color: Colors.black,
          width: 3.0,
        )),
      ),
      height: 60,
      child: Center(
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                backCallBack();
              },
              child: Text(
                "Back",
                style: Constraint.Nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            CustomButton(
              onTap: () {
                nextCallBack();
              },
              buttonTitle: "Next",
              textStyle: Constraint.Nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
