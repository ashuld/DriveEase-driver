import 'dart:developer';

import 'package:drive_ease_driver/view/core/app_router_const.dart';
import 'package:drive_ease_driver/view/providers/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashScreenProvider>(
      builder: (context, splashBuilder, child) {
        return FutureBuilder<String>(
          future: splashBuilder.navigationHandler(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return splashBuilder.buildSplashScreen();
            } else {
              if (snapshot.hasError || snapshot.data == null) {
                return splashBuilder.buildErrorScreen();
              } else {
                final String page = snapshot.data!;
                log(page);
                _navigateAfterDelay(context, page);
                return splashBuilder
                    .buildSplashScreen(); // Show splash screen while waiting
              }
            }
          },
        );
      },
    );
  }

  void _navigateAfterDelay(BuildContext context, String page) {
    Future.delayed(const Duration(seconds: 3), () {
      final navigator = GoRouter.of(context);
      switch (page) {
        case 'notOnBoarded':
          navigator.pushNamed(MyAppRouterConstants.onBoardPage);
          break;
        case 'notSigned':
          navigator.pushNamed(MyAppRouterConstants.registerPage);
          break;
        case 'notloggedIn':
          navigator.pushNamed(MyAppRouterConstants.loginPage);
          break;
        case 'documentNOtSubmitted':
          navigator.pushNamed(MyAppRouterConstants.driverKycAddPage);
          break;
        case 'verifiedBannerNotShown':
          navigator.pushNamed(MyAppRouterConstants.verificationStatusPage);
          break;
        case 'home':
          navigator.pushNamed(MyAppRouterConstants.homePage);
          break;
        default:
          break;
      }
    });
  }
}
