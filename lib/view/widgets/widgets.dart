import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

TextStyle textStyle(
    {Color? color, String? fontStyle, double? size, FontWeight? thickness}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontFamily: fontStyle ?? GoogleFonts.urbanist().fontFamily,
      fontSize: size ?? 15.0,
      fontWeight: thickness ?? FontWeight.normal);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required String message,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.errorColor,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1800),
      content: Text(message.toUpperCase())));
}

Future loadingDialog(context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xff064170),
        content: LottieBuilder.asset('assets/lottie/loading_1.json'),
      );
    },
  );
}
