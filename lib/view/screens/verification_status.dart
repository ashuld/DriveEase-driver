import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:drive_ease_driver/viewmodel/driver_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenVerificationStatus extends StatelessWidget {
  const ScreenVerificationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            Provider.of<AuthProvider>(context, listen: false)
                .fetchDatafromFirestore(context);
            return PopScope(
              canPop: false,
              child: Scaffold(
                body: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration:
                      const BoxDecoration(gradient: AppColors.primaryGradient),
                  child: Consumer<DriverRegistrationProvider>(
                      builder: (context, driver, child) {
                    return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: driver.user?.isVerified == true
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          verifiedBanner(),
                                        ]),
                                    SizedBox(height: 5.w),
                                    verifiedMessage(),
                                    SizedBox(height: 5.w),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [loginButton(context)],
                                    )
                                  ])
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [verificationPendingBanner()],
                                  ),
                                  SizedBox(height: 5.w),
                                  verificationPendingMessage()
                                ],
                              ));
                  }),
                ),
              ),
            );
          } else {
            return const ScaffoldMessenger(child: Text('Something Went Wrong'));
          }
        } else {
          return PopScope(
            canPop: false,
            child: Scaffold(
              body: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: SizedBox(
                    child: LottieBuilder.asset(
                        'assets/lottie/car_loading_future.json'),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Padding verificationPendingMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
      child: Text(
        'Your Request has been received.You can login back once our Team verifies your Request',
        textAlign: TextAlign.start,
        style:
            TextStyle(color: AppColors.linkColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  SizedBox verificationPendingBanner() {
    return SizedBox(
      child: Lottie.asset(
          width: Adaptive.w(50), 'assets/lottie/Pending_verification.json'),
    );
  }

  GestureDetector loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Provider.of<AuthProvider>(context, listen: false)
            .changeBannerStatus(context);
      },
      child: Container(
        width: 55.w,
        height: 6.2.h,
        decoration: BoxDecoration(
          color: AppColors.buttonColor, // Greyish color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: AppColors.buttonSpreadColor, // Shadow color
              offset: Offset(0, 4), // Offset in X and Y direction
              blurRadius: 4, // Spread of the shadow
              spreadRadius: 0.5, // Size of the shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Go To Login',
              style: textStyle(
                  size: 25, color: Colors.white, thickness: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Padding verifiedMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3)),
      child: Text(
        'Your Request has been verified successfully by our Team. Go Back to Login Once More to access the App',
        textAlign: TextAlign.start,
        style:
            TextStyle(color: AppColors.linkColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  SizedBox verifiedBanner() {
    return SizedBox(
        width: 50.w, child: Lottie.asset('assets/lottie/verified.json'));
  }
}
