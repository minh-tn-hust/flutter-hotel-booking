class Notifi {
  bool? read;
  String? hostId;
  String? hotelId;
  String? message;
  String? hotelName;
  String? status;
  int? created;
  String? docId;

  Notifi({
    this.read,
    this.hostId,
    this.hotelId,
    this.message,
    this.hotelName,
    this.status,
    this.created,
    this.docId,
  });

  factory Notifi.fromJson(Map<String, dynamic> json) {
    return Notifi(
      read: json["read"],
      hostId: json["hostId"],
      hotelId: json["hotelId"],
      message: json["message"],
      hotelName: json["hotelName"],
      created: json["created"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["read"] = this.read;
    data["hostId"] = this.hostId;
    data["hotelId"] = this.hotelId;
    data["message"] = this.message;
    data["hotelName"] = this.hotelName;
    data["status"] = this.status;
    data["created"] = this.created;
    return data;
  }
}
