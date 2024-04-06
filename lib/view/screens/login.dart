import 'dart:developer';

import 'package:drive_ease_driver/view/core/app_router_const.dart';
import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/providers/connectivity_provider.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/network_error.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) => log('pop_invoked'),
        child: Scaffold(
          body: Center(
            child: Form(
              key: _formKey,
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration:
                    const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    welcome(),
                    SizedBox(height: 9.5.h),
                    numberField(phoneController),
                    SizedBox(height: 2.5.h),
                    register(context),
                    SizedBox(height: 13.5.h),
                    loginButton(phoneController),
                  ],
                ))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Consumer<ConnectivityProvider> loginButton(
      TextEditingController phoneController) {
    return Consumer<ConnectivityProvider>(
        builder: (context, connectivity, child) {
      return InkWell(
        onTap: () {
          String phone = phoneController.text.trim();
          if (phone.isEmpty) {
            showSnackBar(context: context, message: 'Please Enter Phone No.');
            return;
          }
          if (phone.length != 10) {
            showSnackBar(
                context: context, message: 'Please Enter Valid Phone No.');
            return;
          }
          final auth = Provider.of<AuthProvider>(context, listen: false);
          if (!connectivity.isDeviceConnected) {
            networkDialog(context);
          } else {
            phone = '+91$phone';
            auth.verifyPhoneNumberLogIn(
              context: context,
              phoneNumber: phone,
            );
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
                'Sign In',
                style: textStyle(
                    size: 25, color: Colors.white, thickness: FontWeight.bold),
              ),
            ],
          ),
        ),
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

  Padding register(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Adaptive.w(14.8), 0, 0, 0),
      child: Row(
        children: [
          Text("Don't have an account?",
              style: textStyle(
                  color: AppColors.textColor,
                  size: 18,
                  thickness: FontWeight.w500)),
          InkWell(
            onTap: () {
              GoRouter.of(context)
                  .pushReplacementNamed(MyAppRouterConstants.registerPage);
            },
            child: Text(" Sign Up",
                style: textStyle(
                    color: AppColors.linkColor,
                    size: 16,
                    thickness: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Padding welcome() {
    return Padding(
        padding: EdgeInsets.fromLTRB(Adaptive.w(5.5), 0, 0, 0),
        child: Text(
          "Welcome back! Glad to see you, Again!",
          style: textStyle(
              color: AppColors.textColor, size: 30, thickness: FontWeight.bold),
        ));
  }
}
