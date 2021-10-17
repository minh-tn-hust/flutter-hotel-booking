class PaymentIntent {
  String? paymentIntentId;
  String? image;
  int? amount;
  int? endDate;
  String? hotelAddress;
  String? hotelId;
  String? hotelName;
  String? roomId;
  String? roomName;
  int? beginDate;
  String? customerID;
  int? create;
  int? roomAmount;
  String? status;

  PaymentIntent(
      {this.paymentIntentId,
      this.image,
      this.amount,
      this.endDate,
      this.hotelAddress,
      this.hotelId,
      this.hotelName,
      this.roomId,
      this.roomName,
      this.beginDate,
      this.customerID,
      this.create,
      this.roomAmount,
      this.status});

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      paymentIntentId: json["paymentIntentId"],
      image: json["image"],
      amount: json["amount"],
      endDate: json["endDate"],
      hotelAddress: json["hotelAddress"],
      hotelId: json["hotelId"],
      hotelName: json["hotelName"],
      roomId: json["roomId"],
      roomName: json["roomName"],
      beginDate: json["beginDate"],
      customerID: json["customerID"],
      create: json["create"],
      roomAmount: json["roomAmount"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "paymentIntentId": this.paymentIntentId,
      "image": this.image,
      "amount": this.amount,
      "endDate": this.endDate,
      "hotelAddress": this.hotelAddress,
      "hotelId": this.hotelId,
      "hotelName": this.hotelName,
      "roomId": this.roomId,
      "roomName": this.roomName,
      "beginDate": this.beginDate,
      "customerID": this.customerID,
      "create": this.create,
      "roomAmount": this.roomAmount,
      "status": this.status,
    };
  }
}
