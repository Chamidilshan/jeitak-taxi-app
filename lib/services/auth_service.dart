import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jeitak_app/views/home_page.dart';

class AuthService{

  signInWithGoogle({
    required BuildContext context
}
      ) async{
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context)=>HomeScreen()
        )
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}