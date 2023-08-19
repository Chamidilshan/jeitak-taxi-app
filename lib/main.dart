import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/views/auth_page.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/views/otp_verification_screen.dart';
import 'package:jeitak_app/views/signin_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: AuthPage(),
    );
  }
}
