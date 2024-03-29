import 'package:drive_ease_driver/view/providers/auth_provider.dart'
    as drive_ease_auth_provider;
import 'package:drive_ease_driver/view/providers/connectivity_provider.dart';
import 'package:drive_ease_driver/view/screens/driver_data_add.dart';
import 'package:drive_ease_driver/view/screens/home_page.dart';
import 'package:drive_ease_driver/view/screens/login.dart';
import 'package:drive_ease_driver/view/screens/verification_status.dart';
import 'package:drive_ease_driver/view/widgets/network_error.dart';
import 'package:drive_ease_driver/viewmodel/driver_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<drive_ease_auth_provider.AuthProvider>(context,
        listen: false);
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
      if (!connectivity.isDeviceConnected) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: networkError(),
            ),
          ),
        );
      } else {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              bool isLoggedIn = authSnapshot.hasData;
              if (!isLoggedIn) {
                return const ScreenLogin();
              } else {
                return FutureBuilder(
                  future: auth.fetchDatafromFirestore(context),
                  builder: (context, idSnapshot) {
                    if (idSnapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      final driverProvider =
                          Provider.of<DriverRegistrationProvider>(context,
                              listen: false);
                      if (driverProvider.user?.isDocumentSubmitted == true) {
                        if (driverProvider.user?.isVerifiedBannerShown ==
                            true) {
                          return const ScreenHome();
                        } else {
                          return const ScreenVerificationStatus();
                        }
                      }
                      return ScreenDriverKycAdd();
                    }
                  },
                );
              }
            }
          },
        );
      }
    });
  }
}
