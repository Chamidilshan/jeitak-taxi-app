import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';
import 'package:jeitak_app/widgets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                greenIntroWidget(),
                Positioned(
                  top: 60.0,
                  left: 20.0,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      child: Icon(
                          Icons.arrow_back,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            otpVerificationWidget()
          ],
        ),
      ),
    );
  }
}

