import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/views/home_page.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';
import 'package:jeitak_app/widgets/text_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailControlller = TextEditingController();
  final _passwordControlller = TextEditingController();

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

    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        showDialog(
            context: context,
            builder: (context){
              Navigator.pop(context);
              return AlertDialog(
                title: Text('Please check your password'),
              );
            }
        );

      } else if(e.code == 'wrong-password'){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Please check your rmail address'),
              );
            }
        );
      } else{
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Please try again'),
              );
            }
        );
      }
    }




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
                    Tab(icon: Image.asset("assets/facebook.png", width: 26.0,),),
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
                  Text(" Sign up", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18
                  ),),
                ],
              ),
                  ],
                ),
        ),
            ),

    );
  }
}
