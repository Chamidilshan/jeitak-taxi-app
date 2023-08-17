import 'package:flutter/material.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/utils/constants.dart';
import 'package:jeitak_app/views/login_screen.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';
import 'package:jeitak_app/widgets/text_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: Colors.grey[400])
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
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
            children: [
              Text("Dont have an account? "),
              TextButton(onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              },
                child: Text(
                  "Sign Up",
                style: TextStyle(
                  color: AppColors.mainColor
                ),
              )
              )
            ],
          )
                  ],
                ),
        ),
            ),

    );
  }
}
