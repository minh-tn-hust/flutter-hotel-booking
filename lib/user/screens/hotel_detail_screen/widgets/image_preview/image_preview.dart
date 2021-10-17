import 'package:flutter/material.dart';
import 'package:hotel_booking_app/user/screens/hotel_detail_screen/widgets/image_preview/image_page.dart';

class ImagePreview extends StatefulWidget {
  final List<String> imagePaths;
  const ImagePreview({
    Key? key,
    required this.imagePaths,
    required this.height,
  }) : super(key: key);
  final double height;

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.blue,
      child: PageView.builder(
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) => ImagePage(
          addressList: widget.imagePaths,
          index: index,
          height: widget.height,
        ),
      ),
    );
  }
}
