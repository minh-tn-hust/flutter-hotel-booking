import 'package:hotel_booking_app/models/CustomerInfo/card_info.dart';

class CustomerInfo {
  String? customerID;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? postcode;
  String? country;
  String? mobile;
  List<CardInfo>? cards;
  bool? baned;
  CustomerInfo(
      {this.cards,
      this.customerID,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.postcode,
      this.country,
      this.mobile,
      this.baned});

  String toString() {
    String ans =
        "customerID :${this.customerID}\nfisrtName: ${this.firstName}\nlastName: ${this.lastName}\ncountry: ${this.country}\nmobile: ${this.mobile}\nCARD IS HERE\n${this.cards}\npostCode: ${this.postcode}";
    return ans;
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "postCode": this.postcode,
      "country": this.country,
      "mobile": this.mobile,
    };
  }

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      baned: json["baned"],
      postcode: json["postCode"],
      customerID: json["customerID"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      country: json["country"],
      mobile: json["mobile"],
      cards: (json["cards"] != null)
          ? json["cards"].map<CardInfo>((e) => CardInfo.fromJson(e)).toList()
          : [],
    );
  }
}
