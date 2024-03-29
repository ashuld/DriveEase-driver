import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityProvider extends ChangeNotifier {
  var _isDeviceConnected = false;
  late StreamSubscription<ConnectivityResult> subscription;

  ConnectivityProvider() {
    _initializeConnectivity();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _updateInternetConnection(result);
    });
  }

  Future<void> _initializeConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    log('checking connection');
    _updateInternetConnection(connectivityResult);
  }

  Future<void> _updateInternetConnection(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      log('not connected');
      _isDeviceConnected = await InternetConnectionChecker().hasConnection;
    } else {
      _isDeviceConnected = false;
    }
    notifyListeners();
  }

  bool get isDeviceConnected => _isDeviceConnected;

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
