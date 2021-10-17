import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:provider/provider.dart';

import '../../../constraint.dart';
import 'forget_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.context,
    this.canBack,
  }) : super(key: key);
  final BuildContext context;
  final bool? canBack;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
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
                          controller: emailCtrl,
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
                      Text(
                        "Password",
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
                          controller: passwordCtrl,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This can be empty";
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.black.withOpacity(0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                            var x = await auth.signInWithEmailAndPassword(
                                emailCtrl.text,
                                passwordCtrl.text,
                                widget.context,
                                (widget.canBack != null) ? true : false, (e) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Warning"),
                                      titleTextStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      content: Text("${e.message}"),
                                      contentTextStyle: Constraint.Nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 5,
                                          ),
                                          child: CustomButton(
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
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            });
                          }
                        },
                        buttonTitle: "Login",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("If you don't have a account, ",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          GestureDetector(
                            onTap: () {
                              auth.register();
                            },
                            child: Text(
                              "Register now",
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ResetPasswordForm()));
                            },
                            child: Text(
                              "Forget password?",
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          )
                        ],
                      )
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
}
