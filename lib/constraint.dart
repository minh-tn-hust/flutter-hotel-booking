import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constraint {
  static final Nunito = GoogleFonts.nunito;
  static final HomeHeader =
      Nunito(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white);
  static BoxDecoration AppBarContainerDecoration(bool select) => BoxDecoration(
        gradient: select
            ? LinearGradient(
                colors: [Color(0xFFF8A170), Color(0xFFFFCD61)],
                stops: [0.2, 0.6],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: select
            ? Color.fromRGBO(235, 183, 52, 1)
            : Color.fromRGBO(1, 1, 1, 0),
        borderRadius: BorderRadius.circular(9),
      );
}
