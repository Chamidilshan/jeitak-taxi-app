import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/views/otp_verification_screen.dart';
import 'package:jeitak_app/views/signin_screen.dart';
import 'package:jeitak_app/widgets/text_widget.dart';
import 'package:sign_button/sign_button.dart';

Widget loginWidget(CountryCode countryCode, Function onCountryChange,Function onSubmit, BuildContext context) {
  bool isTextFieldNotEmpty = false;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(

            text: AppConstants.getMovingWithJeitak,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        const SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 3,
                    blurRadius: 3)
              ],
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onCountryChange(),
                    child: Container(
                      child: Row(
                        children: [
                          const SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              child: countryCode.flagImage(),
                            ),
                          ),

                          textWidget(text: countryCode.dialCode),

                          // const SizedBox(width: 10,),

                          Icon(Icons.keyboard_arrow_down_rounded)
                        ],
                      ),
                    ),
                  )),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onEditingComplete: () {
                      // Get.to(
                      //         ()=>OtpVerificationScreen()
                      // );
                    },
                    onSubmitted: (String? input)=>
                        onSubmit(input),

                    //
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.normal),
                        hintText: AppConstants.enterMobileNumber,
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                //Get.to(() => OtpVerificationScreen());
              },
              child: Text(
                  'Send OTP Code',
                style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 12.0
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SignInButton(
              buttonType: ButtonType.googleDark,
              btnColor: AppColors.mainColor,
              onPressed: () {
                print('click');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> SignInScreen(
                        onTap: (){})
                    )
                );
              }),
        ),
        Center(
          child: SignInButton(
            btnColor: AppColors.mainColor,
              buttonType: ButtonType.facebookDark,
              onPressed: () {
                print('click');
              }),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: AppConstants.byCreating + " ",
                  ),
                  TextSpan(
                      text: AppConstants.termsOfService + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                      text: AppConstants.privacyPolicy + " ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ]),
          ),
        )
      ],
    ),
  );
}