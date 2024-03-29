import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 190, 190, 190);
  static const Color buttonColor = Color.fromARGB(255, 143, 143, 143);
  static const Color buttonSpreadColor = Color.fromARGB(255, 103, 103, 103);
  static const Color errorColor = Color.fromARGB(255, 255, 0, 0);
  static const Color formFieldFilled = Colors.white10;
  static const Color formFieldEnabledBorder = Colors.white;
  static const Color formFieldFocusedBorder = Colors.amber;
  static Color linkColor = Colors.amberAccent.withOpacity(0.85);
  static Color textColor =
      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.85);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xff321c59), Color(0xff064170)],
    stops: [0.2, 1],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final Shader gradientShader = const LinearGradient(
    colors: [
      Color.fromARGB(255, 151, 55, 58),
      Color.fromARGB(255, 29, 94, 148)
    ],
    begin: Alignment.topLeft,
    // end: Alignment.bottomLeft,
  ).createShader(const Rect.fromLTRB(60, 20, 10, 60));
}
