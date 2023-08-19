import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jeitak_app/views/home_page.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/views/signin_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          } else{
            return SignInScreen();
          }
        },
      ),
    );
  }
}
