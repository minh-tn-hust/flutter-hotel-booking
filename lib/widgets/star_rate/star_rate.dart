import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constraint.dart';

class RatedStar extends StatelessWidget {
  const RatedStar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
