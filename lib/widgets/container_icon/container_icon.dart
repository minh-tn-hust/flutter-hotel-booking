import 'package:flutter/material.dart';

class ContainerIcon extends StatelessWidget {
  const ContainerIcon({
    Key? key,
    required this.iconSize,
    required this.containerSize,
    required this.radius,
    required this.icon,
  }) : super(key: key);
  final double iconSize;
  final double containerSize;
  final double radius;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerSize,
      width: containerSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
