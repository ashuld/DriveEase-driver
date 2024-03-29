import 'package:drive_ease_driver/firebase_options.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/providers/connectivity_provider.dart';
import 'package:drive_ease_driver/view/providers/utils_provider.dart';
import 'package:drive_ease_driver/view/screens/login.dart';
import 'package:drive_ease_driver/view/screens/onboarding.dart';
import 'package:drive_ease_driver/view/screens/screen_register.dart';
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
          home: FutureBuilder(
            future: util.checkOnBoardingStatus(),
            builder: (context, snapshotOnBoard) {
              if (snapshotOnBoard.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                bool onBoard = snapshotOnBoard.data!;
                if (!onBoard) {
                  return const ScreenOnBoarding();
                } else {
                  final utils =
                      Provider.of<UtilsProvider>(context, listen: false);
                  return FutureBuilder(
                    future: utils.checkSignInStatus(),
                    builder: (context, snapshotSignIn) {
                      if (snapshotSignIn.connectionState ==
                          ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        bool isSigned = snapshotSignIn.data!;
                        if (!isSigned) {
                          return const ScreenRegister();
                        } else {
                          return const ScreenLogin();
                        }
                      }
                    },
                  );
                }
              }
            },
          ),
        );
      });
    });
  }
}
