import 'package:hotel_booking_app/models/HotelAndRoom/hotel.dart';
import 'package:hotel_booking_app/models/HotelAndRoom/hotel_room.dart';
import 'package:hotel_booking_app/models/LocationForMap/location.dart';
import 'package:latlong2/latlong.dart';

class Testing {
  static List<Hotel> hotelData = [
    Hotel(
      rooms: [
        Room(
          imagePath: ["assets/images/hotel_3.png"],
          title: "Normal Room",
          price: 200,
          amenities: [
            "Refundable",
            "BBQ grill",
            "Outdoor dining area",
            "Patio",
            "Kitchen",
            "Hot tub",
            "Wifi",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_2.png"],
          title: "Uper Room",
          price: 400,
          amenities: [
            "Refundable",
            "Patio",
            "Hot tub",
            "BBQ grill",
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_1.png"],
          title: "VIP Room",
          price: 600,
          amenities: [
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
            "Hot tub",
            "Refundable",
            "Patio",
            "BBQ grill",
          ],
        ),
      ],
      imagePath: [
        "assets/images/hotel_1.png",
        "assets/images/hotel_2.png",
        "assets/images/hotel_3.png",
      ],
      name: "Beach Resort Lux",
      lowestPrice: 750,
      highestPrice: 1500,
      location: Location(
        coordinates: LatLng(21.1, 105.5),
        place_name: 'Khách sạn Thượng Lưu',
        text: 'Chịu luôn',
      ),
    ),
    Hotel(
      rooms: [
        Room(
          imagePath: ["assets/images/hotel_2.png"],
          title: "Uper Room",
          price: 400,
          amenities: [
            "Refundable",
            "Patio",
            "Hot tub",
            "BBQ grill",
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_3.png"],
          title: "Normal Room",
          price: 200,
          amenities: [
            "Refundable",
            "BBQ grill",
            "Outdoor dining area",
            "Patio",
            "Kitchen",
            "Hot tub",
            "Wifi",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_1.png"],
          title: "VIP Room",
          price: 600,
          amenities: [
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
            "Hot tub",
            "Refundable",
            "Patio",
            "BBQ grill",
          ],
        ),
      ],
      imagePath: [
        "assets/images/hotel_2.png",
        "assets/images/hotel_1.png",
        "assets/images/hotel_3.png",
      ],
      name: "Ocean View Hotel",
      lowestPrice: 350,
      highestPrice: 1500,
      location: Location(
        coordinates: LatLng(23.1, 105.5),
        place_name: 'Ocean View Hotel',
        text: 'Da Nang, Vietnam',
      ),
    ),
    Hotel(
      rooms: [
        Room(
          imagePath: ["assets/images/hotel_1.png"],
          title: "VIP Room",
          price: 600,
          amenities: [
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
            "Hot tub",
            "Refundable",
            "Patio",
            "BBQ grill",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_3.png"],
          title: "Normal Room",
          price: 200,
          amenities: [
            "Refundable",
            "BBQ grill",
            "Outdoor dining area",
            "Patio",
            "Kitchen",
            "Hot tub",
            "Wifi",
          ],
        ),
        Room(
          imagePath: ["assets/images/hotel_2.png"],
          title: "Uper Room",
          price: 400,
          amenities: [
            "Refundable",
            "Patio",
            "Hot tub",
            "BBQ grill",
            "Outdoor dining area",
            "Wifi",
            "Kitchen",
          ],
        ),
      ],
      imagePath: [
        "assets/images/hotel_3.png",
        "assets/images/hotel_1.png",
        "assets/images/hotel_2.png",
      ],
      name: "Beach Resort Lux",
      lowestPrice: 250,
      highestPrice: 1500,
      location: Location(
        coordinates: LatLng(21.1, 106.5),
        place_name: 'Standard King',
        text: 'Nghe An',
      ),
    ),
  ];
}
