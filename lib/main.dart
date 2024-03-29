import 'package:drive_ease_driver/firebase_options.dart';
import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/providers/connectivity_provider.dart';
import 'package:drive_ease_driver/view/providers/utils_provider.dart';
import 'package:drive_ease_driver/view/screens/onboarding.dart';
import 'package:drive_ease_driver/view/screens/screen_register.dart';
import 'package:drive_ease_driver/viewmodel/auth_wrapper.dart';
import 'package:drive_ease_driver/viewmodel/driver_provider.dart';
import 'package:drive_ease_driver/viewmodel/verification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => VerificationProvider()),
    ChangeNotifierProvider(create: (context) => UtilsProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
    ChangeNotifierProvider(create: (context) => DriverRegistrationProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder:
        (BuildContext context, Orientation orientation, ScreenType screenType) {
      return Consumer<UtilsProvider>(builder: (context, util, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DriveEase-driver',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: pageNavigation(util));
      });
    });
  }

  FutureBuilder<bool> pageNavigation(UtilsProvider util) {
    return FutureBuilder(
      future: util.checkOnBoardingStatus(),
      builder: (context, snapshotOnBoard) {
        if (snapshotOnBoard.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              height: 100.h,
              width: 100.w,
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.textColor,
                ),
              ),
            ),
          );
        } else {
          bool onBoard = snapshotOnBoard.data!;
          if (!onBoard) {
            return const ScreenOnBoarding();
          } else {
            return FutureBuilder(
              future: util.checkSignInStatus(),
              builder: (context, snapshotSignIn) {
                if (snapshotSignIn.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  );
                } else {
                  bool isSigned = snapshotSignIn.data!;
                  if (!isSigned) {
                    return ScreenRegister();
                  } else {
                    return const AuthWrapper();
                  }
                }
              },
            );
          }
        }
      },
    );
  }
}
