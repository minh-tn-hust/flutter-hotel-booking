import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constraint.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Widget getBackGround() {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Image(
          image: AssetImage("assets/images/login_background.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<ApplicationState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            getBackGround(),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          autofocus: false,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty";
                            } else if (!value.contains("@")) {
                              return "Invalid email";
                            }
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FutureBuilder<String>(
                                    future: sendPasswordResetEmail(
                                        emailController.text),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return WillPopScope(
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            onWillPop: () =>
                                                Future.value(false));
                                      }
                                      if (snapshot.hasError) {
                                        AlertDialog(
                                          title: Text("Reset password"),
                                          content:
                                              Text(snapshot.error.toString()),
                                          actions: [
                                            CustomButton(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                buttonTitle: "Confirm",
                                                textStyle: Constraint.Nunito(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                height: 50)
                                          ],
                                        );
                                      }
                                      if (snapshot.data != "Done") {
                                        return AlertDialog(
                                          title: Text("Reset password"),
                                          content: Text(snapshot.data!),
                                          actions: [
                                            CustomButton(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                buttonTitle: "Confirm",
                                                textStyle: Constraint.Nunito(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                height: 50)
                                          ],
                                        );
                                      } else
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text(
                                              "Check your email to reset password"),
                                          actions: [
                                            CustomButton(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                buttonTitle: "Confirm",
                                                textStyle: Constraint.Nunito(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                height: 50)
                                          ],
                                        );
                                    });
                              });
                        },
                        buttonTitle: "Submit",
                        textStyle: Constraint.Nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        height: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> sendPasswordResetEmail(String text) async {
    var res = await http.get(Uri.parse(
        "http://10.0.2.2:5001/booking-app-81eee/us-central1/changePassword?email=$text"));
    var data = jsonDecode(res.body);
    if (data["status"] == "Done") {
      return "Done";
    } else
      throw Exception(data["error"]);
  }
}
