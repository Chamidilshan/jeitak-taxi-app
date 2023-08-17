import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/widgets/otp_input_widget.dart';
import 'package:jeitak_app/widgets/text_widget.dart';

Widget otpVerificationWidget(){
  return Padding(
    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.phoneVerification),
        textWidget(
            text: AppConstants.enterOtp,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          width: Get.width,
            height: 50.0,
            child: RoundedWithShadow()
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: AppConstants.resendCode + " ",
                  ),
                  TextSpan(
                      text: "10 seconds",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                  ),
                ]),
          ),
        )
      ],
    ),
  );
}