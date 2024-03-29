import 'dart:io';

import 'package:drive_ease_driver/view/core/colors.dart';
import 'package:drive_ease_driver/view/providers/auth_provider.dart';
import 'package:drive_ease_driver/view/widgets/widgets.dart';
import 'package:drive_ease_driver/viewmodel/verification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScreenDriverKycAdd extends StatelessWidget {
  ScreenDriverKycAdd({super.key});
  final TextEditingController licenseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerificationProvider>(context);
    return Scaffold(
      body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: SafeArea(
              child: SingleChildScrollView(
            child: SizedBox(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [imgAssigner(provider)],
                    ),
                    SizedBox(height: 2.h),
                    licenseField(licenseController),
                    SizedBox(height: 2.h),
                    licenseFront(provider),
                    SizedBox(height: 2.h),
                    licenseBack(provider),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        submit(context, licenseController, provider),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ))),
    );
  }

  GestureDetector licenseBack(VerificationProvider provider) {
    return GestureDetector(
      onTap: provider.pickBackImage,
      child: Container(
        height: 150,
        width: 100.w,
        decoration: BoxDecoration(
            color: AppColors.formFieldFilled,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: AppColors.formFieldFocusedBorder.withOpacity(0.5))),
        child: provider.backImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(provider.backImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 40,
                    color: AppColors.linkColor,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Upload Your License Back Side',
                    style: textStyle(color: AppColors.linkColor),
                  )
                ],
              ),
      ),
    );
  }

  GestureDetector licenseFront(VerificationProvider provider) {
    return GestureDetector(
      onTap: provider.pickFrontImage,
      child: Container(
        height: 150,
        width: 100.w,
        decoration: BoxDecoration(
            color: AppColors.formFieldFilled,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: AppColors.formFieldFocusedBorder.withOpacity(0.5))),
        child: provider.frontImagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(provider.frontImagePath!),
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: AppColors.linkColor,
                    size: 40,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Upload Your License Front Side',
                    style: textStyle(color: AppColors.linkColor),
                  )
                ],
              ),
      ),
    );
  }

  Stack imgAssigner(VerificationProvider provider) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.textColor)),
            child: SizedBox(
              height: 20,
              width: 20,
              child: provider.driverimage == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/user_avatar.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        File(provider.driverimage!),
                        fit: BoxFit.fill,
                      )),
            )),
        CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 34, 100, 207),
            child: InkWell(
              onTap: () {
                provider.pickImage();
              },
              child: Icon(
                Icons.edit,
                color: AppColors.textColor,
              ),
            ))
      ],
    );
  }

  SizedBox licenseField(TextEditingController licenseController) {
    return SizedBox(
      height: 57,
      child: TextFormField(
        style: TextStyle(color: AppColors.textColor),
        controller: licenseController,
        decoration: InputDecoration(
          hintText: 'Enter Your License No.',
          fillColor: AppColors.formFieldFilled,
          filled: true,
          hintStyle: textStyle(color: AppColors.linkColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.formFieldFocusedBorder.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  InkWell submit(BuildContext context, TextEditingController controller,
      VerificationProvider provider) {
    return InkWell(
      onTap: () {
        final license = controller.text.trim();
        if (license.isEmpty) {
          showSnackBar(context: context, message: 'Enter your LIcense no');
          return;
        }
        if (provider.frontImagePath == null || provider.backImagePath == null) {
          showSnackBar(
              context: context, message: 'Please Submit your license image');
          return;
        }
        if (provider.driverimage == null) {
          showSnackBar(context: context, message: 'Please Upload your image');
          return;
        }
        Provider.of<AuthProvider>(context, listen: false)
            .uploadDriverDetails(context: context, driverLicense: license);
      },
      child: Container(
        width: 70.w,
        height: 6.5.h,
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Submit Your Documents',
                style: textStyle(color: AppColors.textColor)),
          ],
        ),
      ),
    );
  }
}
