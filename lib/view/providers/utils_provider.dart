import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
