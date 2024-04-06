import 'dart:developer';

import 'package:drive_ease_driver/view/core/app_router_const.dart';
import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/widgets/network_error.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/connectivity_provider.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    phoneController.clear();
    nameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => log('popInvoked'),
      child: Scaffold(
        body: Container(
            height: 100.h,
            width: 100.w,
            decoration:
                const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  welcome(),
                  message(),
                  SizedBox(height: 9.h),
                  nameField(nameController),
                  SizedBox(height: 3.h),
                  numberField(phoneController),
                  SizedBox(height: 2.5.h),
                  login(context),
                  SizedBox(height: 8.5.h),
                  signUpButton(nameController, phoneController, context),
                ],
              ),
            )))),
      ),
    );
  }

  Consumer signUpButton(TextEditingController nameController,
      TextEditingController phoneController, BuildContext context) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              String name = nameController.text.trim();
              String phone = phoneController.text.trim();
              if (name.isEmpty || phone.isEmpty) {
                showSnackBar(
                    context: context, message: 'Please Fill All the Fields');
                return;
              }
              if (phoneController.text.length != 10) {
                showSnackBar(
                    context: context,
                    message: 'Please Enter a Valid Phone Number');
                return;
              }
              final auth = Provider.of<AuthProvider>(context, listen: false);
              if (!connectivity.isDeviceConnected) {
                networkDialog(context);
              } else {
                phone = '+91$phone';
                await auth.verifyPhoneNumber(
                    context: context, phoneNumber: phone, name: name);
              }
            },
            child: Container(
              width: 55.w,
              height: 6.2.h,
              decoration: BoxDecoration(
                color: AppColors.buttonColor, // Greyish color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.buttonSpreadColor, // Shadow color
                    offset: Offset(0, 4), // Offset in X and Y direction
                    blurRadius: 4, // Spread of the shadow
                    spreadRadius: 0.5, // Size of the shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: textStyle(
                        size: 25,
                        color: Colors.white,
                        thickness: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Padding numberField(TextEditingController phoneController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ],
        keyboardType: TextInputType.number,
        controller: phoneController,
        style: textStyle(color: Colors.yellow, size: 18),
        decoration: InputDecoration(
            hintText: 'Enter your Phone Number',
            hintStyle: textStyle(color: Colors.yellow),
            filled: true,
            fillColor: AppColors.formFieldFilled,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: AppColors.formFieldFocusedBorder.withOpacity(0.5))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.amber.withOpacity(0.8)))),
      ),
    );
  }

  Padding nameField(TextEditingController nameController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        onTap: () => log('message'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ],
        keyboardType: TextInputType.name,
        controller: nameController,
        style: textStyle(color: Colors.yellow, size: 18),
        decoration: InputDecoration(
            hintText: 'Enter your Name',
            hintStyle: textStyle(color: Colors.yellow),
            filled: true,
            fillColor: AppColors.formFieldFilled,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: AppColors.formFieldFocusedBorder.withOpacity(0.5))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.amber.withOpacity(0.8)))),
      ),
    );
  }

  Row login(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("already have an account?",
            style: textStyle(
                color: AppColors.textColor,
                size: 18,
                thickness: FontWeight.w500)),
        InkWell(
          onTap: () {
            GoRouter.of(context)
                .pushReplacementNamed(MyAppRouterConstants.loginPage);
          },
          child: Text(" Log In Now",
              style: textStyle(
                  color: AppColors.linkColor,
                  size: 16,
                  thickness: FontWeight.bold)),
        ),
      ],
    );
  }

  Padding message() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Adaptive.w(5.5), 0, 0, 0),
      child: Text('sign up and earn with DriveEase',
          style: textStyle(
              color: AppColors.textColor, thickness: FontWeight.bold)),
    );
  }

  Padding welcome() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Adaptive.w(5.5), 0, 0, 0),
      child: Row(
        children: [
          Text(
            "Welcome to Drive",
            style: textStyle(
                color: AppColors.textColor,
                size: 28,
                thickness: FontWeight.bold),
          ),
          Text('Ease',
              style: textStyle(
                color: Colors.lightBlue,
                size: 30,
                thickness: FontWeight.bold,
              ))
        ],
      ),
    );
  }
}
