class CardInfo {
  String? lastFour;
  String? brand;
  String? id;
  CardInfo({
    this.lastFour,
    this.brand,
    this.id,
  });
  String toString() {
    return "{last4: ${this.lastFour},brand: ${this.brand}, id: ${this.id}}";
  }

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      lastFour: json["last4"],
      brand: json["brand"],
      id: json["id"],
    );
  }
}
