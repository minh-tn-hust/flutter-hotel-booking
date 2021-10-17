import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final PickedFile? file;
  final void Function() callBack;
  final double height;
  final double width;
  final String? url;
  const PickImage({
    Key? key,
    required this.file,
    required this.callBack,
    required this.height,
    required this.width,
    this.url,
  }) : super(key: key);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: (widget.file == null)
            ? (widget.url == null)
                ? Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                    ),
                  )
                : FittedBox(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: widget.url!)),
                    fit: BoxFit.fill,
                  )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: FileImage(File(widget.file!.path)),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
