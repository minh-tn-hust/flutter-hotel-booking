import 'package:flutter/material.dart';

import '../../../../constraint.dart';

class ProfileScreenOption extends StatelessWidget {
  const ProfileScreenOption({
    required this.title,
    required this.onTap,
    required this.icon,
    this.trailing,
    Key? key,
  }) : super(key: key);
  final String title;
  final void Function() onTap;
  final Icon icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onTap();
        },
        title: Text(
          title,
          style: Constraint.Nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: trailing,
        leading: CircleAvatar(
          child: icon,
        ),
      ),
    );
  }
}
