import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:jeitak_app/services/auth_service.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/views/home_page.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/views/register_page.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';
import 'package:jeitak_app/widgets/text_widget.dart';

class SignInScreen extends StatefulWidget {
  final Function()? onTap;
  SignInScreen({
    Key? key,
    required this.onTap
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _emailControlller = TextEditingController();
  final _passwordControlller = TextEditingController();
  String welcome = '';


  AuthService authService = AuthService();


  void signUserIn() async{

    showDialog(
        context: context,
        builder: (context){
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          );
        }
    );

    try{

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailControlller.text,
          password: _passwordControlller.text
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context)=>HomeScreen()
          )
      );

    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      print('Failed with error code: ${e.code}');
      print(e.message);
      handleSignInError(e);

    }
  }

  void handleSignInError(FirebaseAuthException e) {
    String errorMessage = '';

    if (e.code == 'user-not-found') {
      errorMessage = 'User not found. Please check your email.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password. Please check your password.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (e.code == 'The password is invalid or the user does not have a password.') {
      errorMessage = 'The password is invalid or the user does not have a password.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      errorMessage = 'An error occurred. Please try again.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic>? _userData;

  Future<UserCredential> signInFacebook() async{
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email']
    );
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      welcome = _userData!['email'];
    });

    final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              greenIntroWidget(),
              const SizedBox(height: 10,),
              textWidget(text: AppConstants.helloWelcomeAgain, fontSize: 16,
                  fontWeight: FontWeight.bold),
              SizedBox(
                height: 10.0,
              ),
              textWidget(text: AppConstants.loginWithJeitak, fontSize: 14,
                  ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10)
                        )
                      ]
                  ),

                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey))
                        ),
                        child: TextField(
                          controller: _emailControlller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Your Email Address",
                              hintStyle: TextStyle(color: Colors.grey[400])
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _passwordControlller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400])
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
          SizedBox(
            height: 20.0,
          ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      signUserIn();
                    },
                    color: AppColors.mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Login", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  ),
                ),
              ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Column(
              children: [
                Text("Or Login with"),
                //const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Tab(

                      icon: GestureDetector(
                        onTap: (){
                          authService.signInWithGoogle(context: context);
                        },
                          child: Image.asset(
                        "assets/facebook.png", width: 26.0,
                          )
                      ),
                    ),
                    //Tab(icon: Image.asset("assets/images/twitter.png")),
                    //Tab(icon: Image.asset("assets/images/github.png")),
                  ],
                )
              ],
            ),
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?"),
                  GestureDetector(
                    child: Text(" Sign up", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                    ),
                    ),
                    onTap: (){
                      widget.onTap;
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> RegisterPage(onTap: (){}))
                      );
                      print('prssed');
                    },
                  ),
                ],
              ),
                  ],
                ),
        ),
            ),

    );
  }
}
