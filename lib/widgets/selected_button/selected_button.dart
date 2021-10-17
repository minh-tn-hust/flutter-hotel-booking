import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SelectedButton extends StatefulWidget {
  const SelectedButton({
    Key? key,
    required this.height,
    required this.title,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  final double height;
  final Text title;
  final bool selected;
  final Function() onTap;

  @override
  _SelectedButtonState createState() => _SelectedButtonState();
}

class _SelectedButtonState extends State<SelectedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          widget.onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: (widget.selected == true)
                ? Colors.orangeAccent
                : Color(0xFFDFDEDE),
            width: (widget.selected == true) ? 2 : 1,
          ),
        ),
        child: Center(
          child: widget.title,
        ),
      ),
    );
  }
}
