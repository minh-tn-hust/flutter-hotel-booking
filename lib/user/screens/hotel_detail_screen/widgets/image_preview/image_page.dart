import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/cache_network_image.dart';

import 'gallery_mode.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({
    Key? key,
    required this.addressList,
    required this.index,
    required this.height,
    this.width,
  }) : super(key: key);
  final int index;
  final List<String> addressList;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryMode(
              childrenAssetString: addressList,
              initPage: index,
            ),
          ),
        );
      },
      child: Container(
        width: width,
        child: CustomCacheImage(
          height: height,
          url: addressList[index],
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
