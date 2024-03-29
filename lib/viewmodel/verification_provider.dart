import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VerificationProvider extends ChangeNotifier {
  String? driverimage;
  String? frontImagePath;
  String? backImagePath;
  Uint8List? driverImage8;
  Uint8List? licenseFrontImage8;
  Uint8List? licenseBackImage8;

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      driverimage = image.path;
      driverImage8 = await image.readAsBytes();
      notifyListeners();
    }
  }

  void pickFrontImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      frontImagePath = image.path;
      licenseFrontImage8 = await image.readAsBytes();
      notifyListeners();
    }
  }

  void pickBackImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      backImagePath = image.path;
      licenseBackImage8 = await image.readAsBytes();
      notifyListeners();
    }
  }
}
