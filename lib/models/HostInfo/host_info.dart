import 'package:hotel_booking_app/models/CustomerInfo/custommerInfo.dart';

class Info {
  String? uid;
  String? email;
  List<String>? hotels;
  CustomerInfo? customerInfo;

  Info({this.uid, this.email, this.hotels, this.customerInfo});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      uid: json["uid"],
      email: json["email"],
      hotels: (json["hotels"] != null)
          ? json["hotels"].map<String>((e) {
              return e.toString();
            }).toList()
          : [],
      customerInfo: json['CustomerInfo'] != null
          ? CustomerInfo.fromJson(json["CustomerInfo"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uid"] = this.uid;
    data["email"] = this.email;
    data["hotels"] = this.hotels;
    if (this.customerInfo != null) {
      data["CustomerInfo"] = this.customerInfo!.toJson();
    }
    return data;
  }

  String toString() {
    return this.toJson().toString();
  }
}
