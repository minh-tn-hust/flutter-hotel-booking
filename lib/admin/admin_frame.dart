import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_booking_app/admin/CheckHotel/check_hotel.dart';
import 'package:hotel_booking_app/admin/CheckHotel/host_tab.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/HostInfo/host_info.dart';
import 'package:hotel_booking_app/models/LoginState/auth_state.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AdminFrame extends StatefulWidget {
  const AdminFrame({Key? key}) : super(key: key);

  @override
  _AdminFrameState createState() => _AdminFrameState();
}

class _AdminFrameState extends State<AdminFrame> {
  @override
  Widget build(BuildContext context) {
    List<Widget> page = [CrudUser(), CrudHost(), CheckHotel()];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Row(
            children: [
              Text(
                "Admin page",
                style: Constraint.Nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Provider.of<ApplicationState>(context, listen: false)
                      .signOut();
                },
                icon: Icon(Icons.logout),
                splashRadius: 15,
              )
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.verified_user),
              ),
              Tab(
                icon: Icon(Icons.manage_accounts),
              ),
              Tab(
                icon: Icon(Icons.hotel),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: page,
        ),
      ),
    );
  }
}

class CrudHost extends StatefulWidget {
  const CrudHost({Key? key}) : super(key: key);

  @override
  _CrudHostState createState() => _CrudHostState();
}

class _CrudHostState extends State<CrudHost> {
  String queryEmail = "";
  Future<List<Info>> getCustomerInfo(String email) async {
    print("Hello");
    List<Info> listHost = [];
    try {
      print("Hi");
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/getHostAccount?email=$email"));
      var data = jsonDecode(res.body);
      data["data"].forEach((element) {
        listHost.add(Info.fromJson(element as Map<String, dynamic>));
      });
      return listHost;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Hello");
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Search with email",
              ),
              onChanged: (value) {
                setState(() {
                  queryEmail = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Info>>(
                future: getCustomerInfo(queryEmail),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  else if (snapshot.hasData) {
                    if (snapshot.data!.length != 0) {
                      return SizedBox.expand(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  HostTab(
                                    info: snapshot.data![index],
                                    callBack: () {
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            }),
                      );
                    } else
                      return Container(
                        child: Center(
                          child: Text(
                            "Not found",
                            style: Constraint.Nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                  } else
                    return Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Somethings wrong in process",
                              style: Constraint.Nunito(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomButton(
                              onTap: () {
                                setState(() {});
                              },
                              buttonTitle: "Refresh",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              height: 65,
                            )
                          ],
                        ),
                      ),
                    );
                }),
          ),
        ],
      ),
    );
  }
}

class CrudUser extends StatefulWidget {
  const CrudUser({Key? key}) : super(key: key);

  @override
  _CrudUserState createState() => _CrudUserState();
}

class _CrudUserState extends State<CrudUser> {
  String queryEmail = "";
  Future<List<Info>> getCustomerInfo(String email) async {
    print("Hello");
    List<Info> listHost = [];
    try {
      print("Hi");
      var res = await http.get(Uri.parse(
          "http://10.0.2.2:5001/booking-app-81eee/us-central1/getUserAccount?email=$email"));
      var data = jsonDecode(res.body);
      data["data"].forEach((element) {
        listHost.add(Info.fromJson(element as Map<String, dynamic>));
      });
      return listHost;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Hello");
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: "Search with email",
              ),
              onChanged: (value) {
                setState(() {
                  queryEmail = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Info>>(
                future: getCustomerInfo(queryEmail),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  else if (snapshot.hasData) {
                    if (snapshot.data!.length != 0) {
                      return SizedBox.expand(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  UserTab(
                                    info: snapshot.data![index],
                                    callBack: () {
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            }),
                      );
                    } else
                      return Container(
                        child: Center(
                          child: Text(
                            "Not found",
                            style: Constraint.Nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                  } else
                    return Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Somethings wrong in process",
                              style: Constraint.Nunito(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomButton(
                              onTap: () {
                                setState(() {});
                              },
                              buttonTitle: "Refresh",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              height: 65,
                            )
                          ],
                        ),
                      ),
                    );
                }),
          ),
        ],
      ),
    );
  }
}

class UserTab extends StatefulWidget {
  const UserTab({
    Key? key,
    required this.info,
    required this.callBack,
  }) : super(key: key);
  final Info info;
  final void Function() callBack;

  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  late String firstName;
  late String lastName;
  late String email;
  late bool? baned;
  TextEditingController descriptionCtrl = TextEditingController();
  int currentLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    firstName = widget.info.customerInfo!.firstName!;
    lastName = widget.info.customerInfo!.lastName!;
    email = widget.info.email!;
    baned = widget.info.customerInfo!.baned;
    super.initState();
  }

  void showInfo(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: SizedBox(
              height: 500,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: InforBottomSheet(
                    customerInfo: widget.info.customerInfo!,
                    uid: widget.info.uid!,
                    callBack: (email, firstName, lastName) async {
                      setState(() {
                        this.email = email;
                        this.firstName = firstName;
                        this.lastName = lastName;
                      });
                      widget.callBack();
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  void showUnbanedDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.black.withOpacity(0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    Response res;
    res = await http.get(Uri.parse(
        "http://10.0.2.2:5001/booking-app-81eee/us-central1/unbanUser?uid=${widget.info.uid}&role=User"));
    var status = jsonDecode(res.body) as Map<String, dynamic>;
    if (status["status"] == "Done") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Done"),
          content: Text(
            "Update successful",
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  if (baned == null) {
                    baned = true;
                  } else {
                    baned = null;
                  }
                });
              },
              buttonTitle: "Confirm",
              textStyle: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              height: 40,
            ),
          ],
        ),
      );
    }
  }

  void showBanedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          height: 400,
          width: 400,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Feedback for user",
                style: Constraint.Nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  autofocus: true,
                  maxLength: 250,
                  controller: descriptionCtrl,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.length;
                    });
                  },
                  decoration: InputDecoration(
                    counterText: currentLength.toString(),
                    counterStyle: Constraint.Nunito(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Why this account has been baned?",
                  ),
                  maxLines: 15,
                  minLines: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: CustomButton(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.black.withOpacity(0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    );
                    Response res;
                    res = await http.get(Uri.parse(
                        "http://10.0.2.2:5001/booking-app-81eee/us-central1/banUser?uid=${widget.info.uid}&role=User"));
                    var status = jsonDecode(res.body) as Map<String, dynamic>;
                    if (status["status"] == "Done") {
                      await FirebaseFirestore.instance
                          .collection("banMessage")
                          .doc(widget.info.uid)
                          .set({"message": descriptionCtrl.text});
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Done"),
                          content: Text(
                            "Update successful",
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            CustomButton(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                setState(() {
                                  if (baned == null) {
                                    baned = true;
                                  } else {
                                    baned = null;
                                  }
                                });
                              },
                              buttonTitle: "Confirm",
                              textStyle: Constraint.Nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              height: 40,
                            ),
                          ],
                        ),
                      );
                    } else
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text("Error"),
                          content: Text(
                            status["message"],
                            style: Constraint.Nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                color: Colors.white,
                              ),
                              height: 40,
                            ),
                          ],
                        ),
                      );
                  },
                  buttonTitle: "Ban",
                  textStyle: Constraint.Nunito(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("=======================");
    print("${widget.info.customerInfo!.baned}");
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: (baned == null) ? Colors.grey : Colors.red,
          width: (baned == null) ? 1 : 1.5,
        ),
      ),
      height: 134,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "UID:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      widget.info.uid!,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Email:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      email,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Name:",
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                    Text(
                      firstName + " " + lastName,
                      style: Constraint.Nunito(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Spacer(),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showInfo(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          "Infomation",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (baned == null) {
                        showBanedDialog();
                      } else {
                        showUnbanedDialog();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(
                          (baned == null) ? "Baned" : "Unbaned",
                          style: Constraint.Nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (baned == null) ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InforBottomSheet extends StatefulWidget {
  const InforBottomSheet({
    Key? key,
    required this.customerInfo,
    required this.uid,
    required this.callBack,
  }) : super(key: key);
  final CustomerInfo customerInfo;
  final String uid;
  final void Function(String email, String firstNmae, String lastName) callBack;

  @override
  _InforBottomSheetState createState() => _InforBottomSheetState();
}

class _InforBottomSheetState extends State<InforBottomSheet> {
  bool? isEnable = false;
  final List<String> labels = [
    "Country",
    "Email",
    "First Name",
    "Last Name",
    "Mobile",
    "Post Code",
  ];
  late List<TextEditingController> controllers;
  @override
  void initState() {
    // TODO: implement initState
    controllers = [
      TextEditingController(text: widget.customerInfo.country),
      TextEditingController(text: widget.customerInfo.email),
      TextEditingController(text: widget.customerInfo.firstName),
      TextEditingController(text: widget.customerInfo.lastName),
      TextEditingController(text: widget.customerInfo.mobile),
      TextEditingController(text: widget.customerInfo.postcode),
    ];
    super.initState();
  }

  final int COUNTRY = 0;
  final int EMAIL = 1;
  final int FIRSTNAME = 2;
  final int LASTNAME = 3;
  final int MOBILE = 4;
  final int POSTCODE = 5;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Text(
            "User Information",
            style: Constraint.Nunito(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            // scrollDirection: Axis.vertical,
            children: List.generate(
              6,
              (index) => Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: (index == EMAIL) ? false : true,
                    onChanged: (value) {
                      if (isEnable != null) {
                        setState(() {
                          isEnable = null;
                        });
                      }
                    },
                    scrollPadding: EdgeInsets.only(left: 5, right: 5),
                    // validator: _validate,
                    controller: controllers[index],
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      labelText: labels[index],
                      labelStyle: Constraint.Nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
              try {
                await FirebaseFirestore.instance
                    .collection("userInfo")
                    .doc(widget.uid)
                    .update({
                  "lastName": controllers[LASTNAME].text,
                  "country": controllers[COUNTRY].text,
                  "firstName": controllers[FIRSTNAME].text,
                  "postCode": controllers[POSTCODE].text,
                  "mobile": controllers[MOBILE].text,
                  "email": controllers[EMAIL].text,
                });
                Navigator.of(context).pop(); // pop the circle
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Done"),
                        content: Text("Data has been updated"),
                      );
                    });
                widget.callBack(controllers[EMAIL].text,
                    controllers[FIRSTNAME].text, controllers[LASTNAME].text);
              } on FirebaseException catch (e) {
                Navigator.of(context).pop(); // pop the circle
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("${e.message!}"),
                      );
                    });
              }
            },
            buttonTitle: "Update information",
            textStyle: Constraint.Nunito(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            height: 60,
            isEnable: isEnable,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
