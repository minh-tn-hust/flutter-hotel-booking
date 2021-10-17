import 'dart:io';

import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:credit_card_input_form/model/card_info.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page.dart';
import 'package:hotel_booking_app/user/screens/reservation/third_page/widgets/second_page/widgets/update_customer_card.dart';
import 'package:hotel_booking_app/widgets/back_button_and_title/back_button_and_title.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../../../../../constraint.dart';

class SecondPage extends StatefulWidget {
  const SecondPage(
      {Key? key,
      required this.customerInfo,
      required this.check,
      this.callBack})
      : super(key: key);
  final CustomerInfo customerInfo;
  final bool check;
  final void Function()? callBack;
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  CardInfo? cardInfo =
      CardInfo(cardNumber: "", validate: "", name: "", cvv: "");
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
              (widget.check == true)
                  ? Row(
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
                            gradient: LinearGradient(
                              colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
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
                    )
                  : Container(),
              SizedBox(
                height: 50,
              ),
              CreditCardInputForm(
                cardName: 'test user',
                cardNumber: '4000002760003184',
                cardValid: '12/21',
                cardCVV: '133',
                showResetButton: true,
                nextButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                prevButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                resetButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                onStateChange: (currentState, CardInfo cardInfo) {
                  setState(() {
                    this.cardInfo = cardInfo;
                  });
                },
              ),
              SizedBox(
                height: 110,
              ),
              CustomButton(
                  onTap: () async {
                    if (cardInfo == null ||
                        cardInfo!.cardNumber == "" ||
                        cardInfo!.cvv == "" ||
                        cardInfo!.name == "" ||
                        cardInfo!.validate == "") {
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
                              content: Text("Your credit card is invalid"),
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
                                      setState(() {});
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
                    } else {
                      var creditCard = CreditCard(
                        number: cardInfo!.cardNumber,
                        expMonth: int.parse(
                            cardInfo!.validate![0] + cardInfo!.validate![1]),
                        expYear: int.parse(
                            cardInfo!.validate![3] + cardInfo!.validate![4]),
                        name: cardInfo!.name,
                        cvc: cardInfo!.cvv,
                      );
                      if (widget.check == true) {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                backgroundColor: Colors.black.withOpacity(0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                )));
                        var res = await Provider.of<ApplicationState>(context,
                                listen: false)
                            .checkCard(creditCard);
                        if (res["Done"] == "Done") {
                          print("SP - DONE - ${widget.customerInfo}");
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdPage(
                                creditCard: creditCard,
                                customerInfo: widget.customerInfo,
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
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
                                  content: Text(res["Error"]!),
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
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              if (widget.customerInfo.customerID == "new")
                                return UpdateCustomerCard(
                                    creditCard: creditCard,
                                    callBack: widget.callBack!,
                                    future: Provider.of<ApplicationState>(
                                            context,
                                            listen: false)
                                        .createCardForNewCustomer(creditCard));
                              return UpdateCustomerCard(
                                future: Provider.of<ApplicationState>(context,
                                        listen: false)
                                    .updateCustomerCard(creditCard),
                                creditCard: creditCard,
                                callBack: widget.callBack!,
                              );
                            });
                      }
                    }
                  },
                  buttonTitle:
                      (widget.check == true) ? "Go to Confirmation" : "Confirm",
                  textStyle: Constraint.Nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  height: 65)
            ],
          ),
        ),
      ),
    );
  }
}
