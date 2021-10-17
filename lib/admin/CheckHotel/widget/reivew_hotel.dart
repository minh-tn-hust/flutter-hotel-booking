import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/admin/CheckHotel/widget/room_review.dart';
import 'package:hotel_booking_app/constraint.dart';
import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/hotel_info.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_preview.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/static_map.dart';
import 'package:hotel_booking_app/widgets/custom_button/custom_button.dart';

class ReviewHotel extends StatefulWidget {
  const ReviewHotel({
    Key? key,
    required this.hotel,
    required this.callBack,
  }) : super(key: key);
  final Hotel hotel;
  final void Function() callBack;

  @override
  _ReviewHotelState createState() => _ReviewHotelState();
}

class _ReviewHotelState extends State<ReviewHotel> {
  TextEditingController descriptionCtrl = TextEditingController();
  int currentLength = 0;
  bool? verity;
  TextStyle style18Bw = Constraint.Nunito(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void initState() {
    // TODO: implement initState
    verity = widget.hotel.verify;
    super.initState();
  }

  void successedUpadte(bool verify) {
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
              setState(() {
                verity = verify;
              });
              widget.callBack();
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
  }

  void errorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Error"),
        content: Text(
          message,
          style: Constraint.Nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomButton(
            onTap: () {
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
  }

  void showRejectDialog() {
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
                "Feedback for host",
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
                    hintText: "Why this hotel has been rejected?",
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
                    print(widget.hotel.hotelID);
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ));
                    try {
                      await FirebaseFirestore
                          .instance // tạo notification cho host
                          .collection("hotelNotifi")
                          .add({
                        "hostId": widget.hotel.hostID,
                        "hotelId": widget.hotel.hotelID,
                        "message": descriptionCtrl.text,
                        "status": "Rejected",
                        "read": false,
                        "created": Timestamp.fromDate(DateTime.now()).seconds,
                      });
                      await FirebaseFirestore
                          .instance // update trạng thái của khách sạn
                          .collection("hotelWithInfo")
                          .doc(widget.hotel.hotelID)
                          .update({"verity": false});
                      Navigator.of(context).pop();
                      successedUpadte(false);
                    } on FirebaseException catch (e) {
                      Navigator.of(context).pop();
                      errorDialog(e.message!);
                    }
                  },
                  buttonTitle: "Reject and Send feedback",
                  textStyle: Constraint.Nunito(
                    fontSize: 18,
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

  void showApproveDialog() async {
    var user = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.hotel.hostID)
        .get();
    if (user.data()!["baned"] == true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Ban user"),
          content: Text(
            "This user has been baned, please unbaned to approve the hotel",
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () {
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
    } else if (widget.hotel.hostID == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Ban user"),
          content: Text(
            "This user has been deleted, can't approve this hotel",
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () {
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
    } else
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Approve"),
          content: Text(
            "Activate this hotel to begin booking",
            style: Constraint.Nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            CustomButton(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => Center(
                          child: CircularProgressIndicator(),
                        ));
                try {
                  await FirebaseFirestore.instance // tạo notification cho host
                      .collection("hotelNotifi")
                      .add({
                    "hostId": widget.hotel.hostID,
                    "hotelName": widget.hotel.name,
                    "hotelId": widget.hotel.hotelID,
                    "message": descriptionCtrl.text,
                    "status": "active",
                    "read": false,
                    "created": Timestamp.fromDate(DateTime.now()).seconds,
                  }).then((value) => print(value));
                  await FirebaseFirestore
                      .instance // update trạng thái của khách sạn
                      .collection("hotelWithInfo")
                      .doc(widget.hotel.hotelID)
                      .update({"verity": true});
                  Navigator.of(context).pop();
                  successedUpadte(true);
                } on FirebaseException catch (e) {
                  Navigator.of(context).pop();
                  errorDialog(e.message!);
                }
              },
              buttonTitle: "Confirm",
              textStyle: Constraint.Nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              height: 40,
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              buttonTitle: "Cancel",
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

  @override
  Widget build(BuildContext context) {
    print(widget.hotel.verify);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (verity == null || verity == true)
            FloatingActionButton(
              // từ chối duyệt khách sạn
              heroTag: null,
              onPressed: () {
                showRejectDialog();
              },
              child: Center(
                child: Icon(Icons.no_encryption),
              ),
            ),
          if (verity == null || verity == true)
            SizedBox(
              height: 10,
            ),
          if (verity == null || verity == false)
            FloatingActionButton(
              // xác nhận khách sạn đã được duyệt
              heroTag: null,
              onPressed: () async {
                showApproveDialog();
              },
              child: Center(
                child: Icon(Icons.verified),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ImagePreview(
              imagePaths: widget.hotel.imagePath!,
              height: 335,
            ),
            //edit title detail room and star
            Container(
              margin: EdgeInsets.only(
                left: 17,
                right: 17,
                top: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 290,
                    child: Text(
                      "${widget.hotel.name}",
                      style: Constraint.Nunito(
                        fontSize: (widget.hotel.name!.length > 20) ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: (verity == null)
                          ? Colors.greenAccent
                          : (verity == true)
                              ? Colors.orangeAccent
                              : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      (verity == null)
                          ? "Pending"
                          : (verity == true)
                              ? "Approve"
                              : "Rejected",
                      style: style18Bw,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
              ),
              child: Text(
                "${widget.hotel.location!.text}",
                style: Constraint.Nunito(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
              ),
              child: Text(
                "From \$${widget.hotel.lowestPrice!} to \$${widget.hotel.highestPrice!}",
                style: Constraint.Nunito(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 17,
                right: 17,
              ),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Description: ",
                    style: Constraint.Nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: widget.hotel.description,
                    style: Constraint.Nunito(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: StaticMap(
                  location: widget.hotel.location!.coordinates,
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text(
                "Amenities",
                style: Constraint.Nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),

            //below maps
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Center(
                child: HotelInfo(
                  children: widget.hotel.amenities!,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text(
                "Rooms",
                style: Constraint.Nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              children: widget.hotel.rooms!
                  .map((e) => Column(
                        children: [
                          RoomReview(room: e),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
