import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/widgets/second_page/second_page.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var keyForm = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var address = TextEditingController();
  var postCode = TextEditingController();
  var country = TextEditingController();
  var mobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButtonAndTitle(title: "Reservation"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[350],
                    ),
                    child: Center(
                      child: Text(
                        "2",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[350],
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: Constraint.Nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your first name";
                              if (value.isEmpty) {
                                return "Fill your first name";
                              }
                            },
                            controller: firstName,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "First Name",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your last name";
                              }
                            },
                            controller: lastName,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "Last Name",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your Email Address";
                              }
                            },
                            controller: email,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your address";
                              }
                            },
                            controller: address,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "Address",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your post code";
                              }
                            },
                            controller: postCode,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "Post Code",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your country";
                              }
                            },
                            controller: country,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "Country",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) return "Fill your last name";
                              if (value.isEmpty) {
                                return "Fill your mobile";
                              }
                            },
                            controller: mobile,
                            decoration: InputDecoration(
                              labelStyle: Constraint.Nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              labelText: "Mobile",
                              fillColor: Colors.grey[250],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                onTap: () {
                  if (keyForm.currentState!.validate()) {
                    var customerInfo = CustomerInfo(
                      customerID: "new",
                      firstName: firstName.value.text,
                      lastName: lastName.value.text,
                      email: email.value.text,
                      address: address.value.text,
                      postcode: postCode.value.text,
                      country: country.value.text,
                      mobile: mobile.value.text,
                      baned: null,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondPage(
                          customerInfo: customerInfo,
                          check: true,
                        ),
                      ),
                    );
                  }
                },
                buttonTitle: "Go to Payment",
                textStyle: Constraint.Nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                height: 65,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
