import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.buttonTitle,
    required this.textStyle,
    required this.height,
    this.isEnable,
  }) : super(key: key);
  final void Function() onTap;
  final String buttonTitle;
  final TextStyle textStyle;
  final double height;
  final bool? isEnable;
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: (widget.isEnable == null)
            ? LinearGradient(
                colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: (widget.isEnable == null) ? null : Colors.grey,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.buttonTitle,
            style: widget.textStyle,
          ),
        ),
        onPressed: (widget.isEnable == null) ? widget.onTap : null,
      ),
    );
  }
}
