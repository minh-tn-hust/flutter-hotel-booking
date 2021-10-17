import 'package:flutter/material.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/Firebase/firebase_service.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user/screens/notifcation_screen/widgets/history_tab.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:hotel_booking_app/widgets/login_screen/login_screen.dart';
import 'package:hotel_booking_app/widgets/login_screen/widgets/login_form.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ApplicationState>(context).user;
    var customerInfo = Provider.of<ApplicationState>(context).customerInfo;
    print(user);
    print(customerInfo);
    return SizedBox.expand(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Payment History",
                  style: Constraint.Nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (customerInfo != null)
              FutureBuilder<List<dynamic>>(
                  future:
                      FirebaseService.instance().loadHistoryFromUser(user!.uid),
                  builder: (context, snapshot) {
                    print("snapshot data = ${snapshot.data}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    var listHistory = snapshot.data;
                    if (listHistory!.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "No payment found in your account",
                            style: Constraint.Nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: listHistory.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              HistoryCard(
                                color: Colors.deepOrange,
                                docId:
                                    listHistory[listHistory.length - 1 - index],
                                callBack: () {
                                  setState(() {});
                                },
                              )
                            ],
                          );
                        },
                      ),
                    );
                  })
            else
              Expanded(
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login to see this part",
                          style: Constraint.Nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: CustomButton(
                            onTap: () {
                              Provider.of<ApplicationState>(context,
                                      listen: false)
                                  .login();
                            },
                            buttonTitle: "Login now",
                            textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            height: 50,
                          ),
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
