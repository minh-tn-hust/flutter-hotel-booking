class Room {
  String? id;
  List<String>? imagePath;
  String? title;
  int? recentAvailable;
  List<String>? amenities;
  double? price;
  Room({
    this.id,
    this.imagePath,
    this.recentAvailable,
    this.title,
    this.amenities,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "imagePath": imagePath,
      "title": title,
      "recentAvailable": recentAvailable,
      "amenities": amenities,
      "price": price,
      "id": id,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      imagePath: json["imagePath"]
          .map<String>((element) => element.toString())
          .toList(),
      recentAvailable: json["recentAvailable"],
      title: json["title"],
      amenities: json["amenities"]
          .map<String>((element) => element.toString())
          .toList(),
      price: json["price"].toDouble(),
    );
  }
}
