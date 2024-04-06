import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';

class UtilsProvider extends ChangeNotifier {
  Future<bool> checkOnBoardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onBoard = prefs.getBool('onBoard') ?? false;
    if (onBoard) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSigned = prefs.getBool('isSigned') ?? false;
    if (isSigned) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkLoginStatus(BuildContext context) async {
    final driver = Provider.of<AuthProvider>(context, listen: false);
    await driver.getCurrentUserId();
    if (driver.uid == null) {
      return false;
    } else {
      return true;
    }
  }
}
