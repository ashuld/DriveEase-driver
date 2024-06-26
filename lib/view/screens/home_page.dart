import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: SafeArea(
            child: Column(
              children: [
                Center(
                    child: Text(
                  'Home Page',
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
