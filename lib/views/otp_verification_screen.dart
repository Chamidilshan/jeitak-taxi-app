import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/controllers/auth_controller.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';
import 'package:jeitak_app/widgets/otp_input_widget.dart';
import 'package:jeitak_app/widgets/otp_verification_widget.dart';
import 'package:jeitak_app/widgets/text_widget.dart';

class OtpVerificationScreen extends StatefulWidget {

  String phoneNumber;
  OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {


  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   //authController.phoneAuth(widget.phoneNumber);
  }

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
                  top: 60,
                  left: 30,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back,color: AppColors.mainColor,size: 20,),
                    ),
                  ),
                ),


              ],
            ),

            SizedBox(
              height: 50,
            ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(text: AppConstants.phoneVerification),
            textWidget(
                text: AppConstants.enterOtp,
                fontSize: 22,
                fontWeight: FontWeight.bold),
            const SizedBox(
              height: 40,
            ),


            Container(

                width: Get.width,
                height: 50,
                child: RoundedWithShadow()
            ),
            const SizedBox(
              height: 40,
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
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),

                    ]),
              ),
            )
          ],
        ),
      )


          ],
        ),
      ),
    );
  }
}