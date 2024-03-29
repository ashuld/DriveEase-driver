import 'dart:developer';

import 'package:drive_ease_driver/model/driver_model.dart';
import 'package:flutter/material.dart';

class DriverRegistrationProvider extends ChangeNotifier {
  DriverDetails? _user;

  DriverDetails? get user => _user;

  void updateDriverInfo({required DriverDetails driverdata}) {
    _user = DriverDetails(
        fullName: driverdata.fullName,
        phoneNumber: driverdata.phoneNumber,
        isVerified: driverdata.isVerified,
        userid: driverdata.userid,
        isBlocked: driverdata.isBlocked,
        isDocumentSubmitted: driverdata.isDocumentSubmitted,
        isVerifiedBannerShown: driverdata.isVerifiedBannerShown,
        kycData: driverdata.kycData
        // Initialize other user-related properties here if needed.
        );
    log("${_user?.fullName},${_user?.isDocumentSubmitted}");
    notifyListeners();
  }
}
