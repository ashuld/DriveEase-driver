import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Container networkError() {
  return Container(
    decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
    child: Column(
      children: [
        LottieBuilder.asset(height: 50.h, 'assets/lottie/network_lottie.json'),
        Text(
          'You have been disconnected from the Internet.\nPlease check Your Internet connection',
          style: textStyle(color: Colors.amberAccent),
        ),
      ],
    ),
  );
}

Future networkDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xff064170),
        title: Text(
          'No Internet Connection',
          style: textStyle(color: AppColors.textColor),
        ),
        content: Text(
          'Please check your internet connection and try again.',
          style: textStyle(color: AppColors.textColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'OK',
              style: textStyle(color: AppColors.textColor),
            ),
          ),
        ],
      );
    },
  );
}
