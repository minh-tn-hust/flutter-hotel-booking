import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BanedScreen extends StatefulWidget {
  const BanedScreen({Key? key}) : super(key: key);

  @override
  _BanedScreenState createState() => _BanedScreenState();
}

class _BanedScreenState extends State<BanedScreen> {
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

  Future<String> getMessage(String uid) async {
    try {
      var value = await FirebaseFirestore.instance
          .collection("banMessage")
          .doc(uid)
          .get();
      return value.data()!["message"];
    } on FirebaseException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<ApplicationState>(context).user!.uid;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            getBackGround(),
            SizedBox.expand(
              child: FutureBuilder<String>(
                  future: getMessage(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "You has been baned with the reason: ",
                                      style: Constraint.Nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${snapshot.data}",
                                      style: Constraint.Nunito(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomButton(
                              onTap: () {
                                Provider.of<ApplicationState>(context,
                                        listen: false)
                                    .signOut();
                              },
                              buttonTitle: "Log out",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              height: 50,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
