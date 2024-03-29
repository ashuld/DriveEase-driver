// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_ease_driver/model/driver_model.dart';
import 'package:drive_ease_driver/view/screens/driver_data_add.dart';
import 'package:drive_ease_driver/view/screens/home_page.dart';
import 'package:drive_ease_driver/view/screens/login.dart';
import 'package:drive_ease_driver/view/screens/otp_verification.dart';
import 'package:drive_ease_driver/view/screens/verification_status.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:drive_ease_driver/viewmodel/driver_provider.dart';
import 'package:drive_ease_driver/viewmodel/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _uid;
  String? _verificationId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => _uid;
  String? get verificationId => _verificationId;

  Future<void> verifyPhoneNumber(
      {required BuildContext context,
      required String phoneNumber,
      required String name}) async {
    try {
      loadingDialog(context);
      final driverSnapshot = await _firestore
          .collection('drivers')
          .where('phone', isEqualTo: phoneNumber)
          .get();
      if (driverSnapshot.docs.isNotEmpty) {
        Navigator.pop(context);
        showSnackBar(
            context: context,
            message:
                'Phone Number Already Registered! Please go to Login Page');
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            Navigator.pop(context);
            log("Verification Failed: ${error.message}");
            showSnackBar(
                context: context,
                message:
                    'Something Happened! Please Try Again After few Minutes');
          },
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
            notifyListeners();
            Navigator.pop(context);
            Navigator.push(
                context,
                CustomPageTransition(
                    page: ScreenOtpVerification(
                  name: name,
                  phoneNo: phoneNumber,
                  isFromRegistration: true,
                )));
            log('code sent');
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
    }
  }

  Future<void> verifyOTPSignIn(
      {required BuildContext context,
      required String otp,
      required DriverDetails driverdata}) async {
    try {
      loadingDialog(context);
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        log('verification successful');
        _uid = user.uid;
        log('saving data to firestore');
        saveDriverInformation(context, driverdata);
      }
    } catch (e) {
      Navigator.pop(context);
      log(e.toString());
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
    }
  }

  Future<void> getCurrentAdminId() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc =
          await _firestore.collection('drivers').doc(user.uid).get();
      notifyListeners();
      if (userDoc.exists) {
        _uid = user.uid;
        notifyListeners(); // Return the adminId
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      loadingDialog(context);
      await _auth.signOut();
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenLogin(),
          ));
      log("Sign Out Successful");
    } catch (e) {
      log("Error during sign out: $e");
    }
  }

  Future<void> verifyPhoneNumberLogIn(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      loadingDialog(context);
      final userSnapshot = await _firestore
          .collection('drivers')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        log("User exists! Let's go to verification page");
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            log('signed up with credential');
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (error) {
            //Handle verification failure
            log("Verification Failed: ${error.message}");
            Navigator.pop(context);
            showSnackBar(
                context: context,
                message:
                    'Something Happened! Please Try Again After few Minutes');
          },
          codeSent: (verificationId, forceResendingToken) {
            // Save the verificationId and navigate to OTP verification page.
            log('otp sent');
            _verificationId = verificationId;
            notifyListeners();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenOtpVerification(
                      phoneNo: phoneNumber, isFromRegistration: false),
                ));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            // Display an error message to the user or provide an option to resend the code manually.
          },
        );
      } else {
        // User does not exist.
        Navigator.pop(context);
        showSnackBar(
            context: context,
            message: 'User does not Exist. Please go to Register Page');
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
      log('Error verifying mobile number: ${e.toString()}');
    }
  }

  Future<void> verifyOTPLogIn(BuildContext context,
      {required String otp}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);
    try {
      loadingDialog(context);
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;
      if (user != null) {
        log('otp verification successfull');
        _uid = user.uid;
        notifyListeners();
        //After Successful login
        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('drivers')
            .doc("kVokZGrvHLd5v9WTkH5M4t3V9XR2")
            .get();
        log('enterred here1');
        log(userDataSnapshot.data().toString());
        if (userDataSnapshot.exists) {
          final driverProvider =
              Provider.of<DriverRegistrationProvider>(context, listen: false);

          DriverDetails driverData =
              await extractDriverDetails(userDataSnapshot);
          driverProvider.updateDriverInfo(driverdata: driverData);
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setBool('isSigned', true);
          if (driverProvider.user?.isDocumentSubmitted == true) {
            if (driverProvider.user?.isVerifiedBannerShown == true) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenHome(),
                  ));
            } else {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenVerificationStatus(),
                  ));
            }
          } else {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenDriverKycAdd(),
                ));
          }
        } else {
          Navigator.pop(context);
          showSnackBar(context: context, message: 'User Data Not Found');
        }
      } else {
        Navigator.pop(context);
        showSnackBar(context: context, message: 'OTP Verfication Failed');
        log('OTP Verification failed.');
      }
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
      // Handle verification exception.
      log('OTP Verification error: ${e.toString()}');
    }
  }

  Future<void> resendOTP(
      {required String phoneNumber, required BuildContext context}) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('signed up with credential-resend otp');
          await auth.signInWithCredential(credential);
          // Verification completed automatically
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(
              context: context,
              message:
                  'Something Happened! Please Try Again After few Minutes');
          // Handle verification failure
          log("Verification Failed-resend otp: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          notifyListeners();
          // Code Successfully sent
          log('resend otp sent');
          showSnackBar(context: context, message: 'Code Sent Successfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Display an error message to the user or provide an option to resend the code manually.
        },
      );
    } catch (e) {
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
      // Handle verification failure
      log("Verification Failed-resend otp: ${e.toString()}");
    }
  }

  Future<void> saveDriverInformation(
      BuildContext context, DriverDetails driverdata) async {
    try {
      await _firestore.collection('drivers').doc(_uid).set({
        'name': driverdata.fullName,
        'phone': driverdata.phoneNumber,
        'isDocumentSubmitted': driverdata.isDocumentSubmitted,
        'isVerified': driverdata.isVerified,
        'userid': _uid,
        'isVerifiedBannerShown': driverdata.isVerifiedBannerShown,
        'isBlocked': driverdata.isBlocked
      });
      log('successfully added to firestore');
      Provider.of<DriverRegistrationProvider>(context, listen: false)
          .updateDriverInfo(driverdata: driverdata);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isSigned', true);
      Navigator.pop(context);
      notifyListeners();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenDriverKycAdd(),
          ));
      // Driver information saved to Firestore successfully.
    } catch (e) {
      // Handle Firestore save error.
      Navigator.pop(context);
      notifyListeners();
      showSnackBar(
          context: context,
          message: 'Something Happened! Please Try Again After few Minutes');
      log('Error saving driver information: ${e.toString()}');
    }
  }

  //extracting details
  Future<DriverDetails> extractDriverDetails(
      DocumentSnapshot userDataSnapShot) async {
    var fullName =
        (userDataSnapShot.data() as Map<String, dynamic>)['name'] ?? '';
    var isBlocked =
        (userDataSnapShot.data() as Map<String, dynamic>)['isBlocked'] ?? false;
    var isDocumentSubmitted = (userDataSnapShot.data()
            as Map<String, dynamic>)['isDocumentSubmitted'] ??
        false;
    var kycData = userDataSnapShot['kycData'] ?? {};
    var userid =
        (userDataSnapShot.data() as Map<String, dynamic>)['userid'] ?? '';
    var phoneNumber =
        (userDataSnapShot.data() as Map<String, dynamic>)['phone'] ?? '';
    var isVerified =
        (userDataSnapShot.data() as Map<String, dynamic>)['isVerified'] ??
            false;
    var isVerifiedBannerShown = (userDataSnapShot.data()
            as Map<String, dynamic>)['isVerifiedBannerShown'] ??
        false;
    log('$fullName,$phoneNumber,$isDocumentSubmitted,$isVerified,$isBlocked');
    return DriverDetails(
        fullName: fullName,
        isVerifiedBannerShown: isVerifiedBannerShown,
        userid: userid,
        phoneNumber: phoneNumber,
        isDocumentSubmitted: isDocumentSubmitted,
        isVerified: isVerified,
        kycData: kycData,
        isBlocked: isBlocked);
  }

  fetchDatafromFirestore(BuildContext context) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.getCurrentAdminId();
      final userid = auth.uid;
      final snapshot = await _firestore.collection('drivers').doc(userid).get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          final driverDetails = DriverDetails(
              fullName: data['name'] ?? '',
              phoneNumber: data['phone'] ?? '',
              userid: data['userid'] ?? '',
              isDocumentSubmitted: data['isDocumentSubmitted'] ?? false,
              isVerified: data['isVerified'] ?? false,
              isVerifiedBannerShown: data['isVerifiedBannerShown'] ?? false,
              isBlocked: data['isBlocked'] ?? false,
              kycData: data['kycData'] ?? {});
          // Store driverDetails object in shared preferences
          final driverProvider =
              Provider.of<DriverRegistrationProvider>(context, listen: false);
          driverProvider.updateDriverInfo(driverdata: driverDetails);
          notifyListeners();
          log('${driverDetails.fullName},${driverDetails.phoneNumber},${driverDetails.isDocumentSubmitted},${driverDetails.isVerified},${driverDetails.isVerifiedBannerShown},${driverDetails.isBlocked}');
          if (driverProvider.user?.isDocumentSubmitted == true) {
            if (driverProvider.user?.isVerifiedBannerShown == true) {
              return const ScreenHome();
            } else {
              return const ScreenVerificationStatus();
            }
          } else {
            return const ScreenDriverKycAdd();
          }
        }
      } else {
        showSnackBar(
            context: context,
            message: 'Something Happened! Please Try Again After few Minutes');
      }
    } catch (e) {
      log('Error fetching and storing driver data: $e');
    }
  }
}