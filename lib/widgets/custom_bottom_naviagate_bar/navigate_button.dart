import 'package:flutter/material.dart';

import '../../constraint.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton(
      {Key? key,
      required this.onTap,
      required this.selected,
      required this.icon})
      : super(key: key);
  final Function() onTap;
  final bool selected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        height: 50,
        width: 50,
        decoration: Constraint.AppBarContainerDecoration(selected),
        child: Icon(
          icon,
          color: (selected ? Colors.white : Colors.black),
          size: 24,
        ),
      ),
    );
  }
}
