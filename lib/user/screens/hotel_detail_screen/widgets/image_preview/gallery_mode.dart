import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryMode extends StatelessWidget {
  const GalleryMode(
      {Key? key, required this.childrenAssetString, required this.initPage})
      : super(key: key);
  final List<String> childrenAssetString;
  final int initPage;
  @override
  Widget build(BuildContext context) {
    PageController _pageController = new PageController(
      initialPage: initPage,
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: PhotoViewGallery.builder(
            itemCount: childrenAssetString.length,
            pageController: _pageController,
            builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider:
                  CachedNetworkImageProvider('${childrenAssetString[index]}'),
              initialScale: PhotoViewComputedScale.contained,
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
