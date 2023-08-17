import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/views/otp_verification_screen.dart';
import 'package:jeitak_app/views/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      title: 'Jeitak',
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme)
      ),
      home: SignInScreen(),
    );
  }
}
