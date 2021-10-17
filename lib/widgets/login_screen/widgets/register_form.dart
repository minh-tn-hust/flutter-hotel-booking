import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.context,
    this.canBack,
  }) : super(key: key);
  final BuildContext context;
  final bool? canBack;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String value = "User";
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
              top: 150,
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
                      Text(
                        "Role",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 2),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          icon: Icon(Icons.more),
                          onChanged: (value) {
                            setState(() {
                              this.value = value!;
                            });
                          },
                          underline: SizedBox(),
                          items: [
                            DropdownMenuItem(
                              child: Text("User"),
                              value: "User",
                            ),
                            DropdownMenuItem(
                                child: Text("Host"), value: "Host"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        //Register Button
                        onTap: () {
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
                            var x = auth.registerAccount(
                                emailCtrl.text,
                                value,
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
                        buttonTitle: "Register",
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
                          Text(
                            "If you have a account, ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              auth.login();
                            },
                            child: Text(
                              "Login",
                              style: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
