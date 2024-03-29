import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenVerificationStatus extends StatelessWidget {
  const ScreenVerificationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          children: [
            Center(
                child: Text(
              'Verification Status',
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ))
          ],
        ),
      ),
    );
  }
}
