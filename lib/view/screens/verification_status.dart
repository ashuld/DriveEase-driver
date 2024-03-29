import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenVerificationStatus extends StatelessWidget {
  const ScreenVerificationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              height: 100.h,
              width: 100.w,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.textColor,
                ),
              ),
            ),
          );
        } else {
          // ignore: prefer_const_constructors
          return Center();
        }
      },
    );
  }
}
