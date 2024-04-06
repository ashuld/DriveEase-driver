import 'package:drive_ease_driver/view/core/app_router_const.dart';
import 'package:drive_ease_driver/view/screens/driver_data_add.dart';
import 'package:drive_ease_driver/view/screens/home_page.dart';
import 'package:drive_ease_driver/view/screens/login.dart';
import 'package:drive_ease_driver/view/screens/onboarding.dart';
import 'package:drive_ease_driver/view/screens/otp_verification.dart';
import 'package:drive_ease_driver/view/screens/screen_register.dart';
import 'package:drive_ease_driver/view/screens/splash_screen.dart';
import 'package:drive_ease_driver/view/screens/verification_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyAppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: MyAppRouterConstants.splashPage,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenSplash();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.otpPage,
        path: '/otp_verification/:phoneNo/:isFromRegistration/:name',
        pageBuilder: (context, state) {
          final String? phoneNo = state.pathParameters['phoneNo'];
          final String? isFromRegistration =
              state.pathParameters['isFromRegistration'];
          final String? name = state.pathParameters['name'];
          bool isRegistration = isFromRegistration == 'true';
          return MaterialPage(child: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return ScreenOtpVerification(
                  name: name,
                  phoneNo: phoneNo!,
                  isFromRegistration: isRegistration);
            },
          ));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.onBoardPage,
        path: '/onBoard',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenOnBoarding();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.registerPage,
        path: '/driver_register',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenRegister();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.driverKycAddPage,
        path: '/driver_kyc_add',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenDriverKycAdd();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.verificationStatusPage,
        path: '/verification_status',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenVerificationStatus();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.loginPage,
        path: '/login',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenLogin();
          }));
        },
      ),
      GoRoute(
        name: MyAppRouterConstants.homePage,
        path: '/home',
        pageBuilder: (context, state) {
          return MaterialPage(child:
              ResponsiveSizer(builder: (context, orientation, screenType) {
            return const ScreenHome();
          }));
        },
      ),
    ],
  );
}
