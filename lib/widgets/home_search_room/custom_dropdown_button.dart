import 'package:flutter/material.dart';

import '../../../../../../constraint.dart';

class CustomDropdownButton extends StatefulWidget {
  final String digit;
  final String hintText;
  final List<int> children;
  final Function(int? number) onChange;
  const CustomDropdownButton({
    Key? key,
    required this.digit,
    required this.hintText,
    required this.children,
    required this.onChange,
  }) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  int? valueChoose;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 50,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color.fromRGBO(223, 222, 222, 0.1),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        style: Constraint.Nunito(color: Color.fromRGBO(223, 222, 222, 1)),
        underline: SizedBox(),
        hint: Text(
          "${widget.hintText}",
          style: Constraint.Nunito(fontSize: 16, color: Colors.grey),
        ),
        isExpanded: true,
        // value: valueChoose,
        focusColor: Color.fromRGBO(223, 222, 222, 1),
        dropdownColor: Color(0xFF393939),
        value: valueChoose,
        onChanged: (int? itemValue) {
          setState(() {
            valueChoose = itemValue;
          });
          widget.onChange(itemValue);
        },
        items: widget.children
            .map((valueItem) => DropdownMenuItem(
                  value: valueItem,
                  child: Text("${valueItem + 1} ${widget.digit}"),
                ))
            .toList(),
      ),
    );
  }
}
