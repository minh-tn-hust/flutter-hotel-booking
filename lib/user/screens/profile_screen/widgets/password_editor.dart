import 'package:flutter/material.dart';

import '../../../../constraint.dart';

class PasswordEditor extends StatelessWidget {
  const PasswordEditor(
      {Key? key, required this.controller, required this.title, this.validate})
      : super(key: key);
  final String title;
  final String? Function(String? value)? validate;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Constraint.Nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: TextFormField(
        validator: validate,
        style: Constraint.Nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
