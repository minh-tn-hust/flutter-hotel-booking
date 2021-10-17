import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user_frame.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

class Role extends StatelessWidget {
  const Role({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // vào flow dành cho host
                CustomButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Consumer<ApplicationState>(
                          builder: (context, state, _) =>
                              LoginScreen(state: state),
                        ),
                      ),
                    );
                  },
                  buttonTitle: "HOST",
                  textStyle: Constraint.Nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                // vào flow dành cho user
                CustomButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserFrame(),
                      ),
                    );
                  },
                  buttonTitle: "USER",
                  textStyle: Constraint.Nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
