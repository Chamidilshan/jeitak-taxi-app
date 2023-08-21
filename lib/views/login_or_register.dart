import 'package:flutter/material.dart';
import 'package:jeitak_app/views/register_page.dart';
import 'package:jeitak_app/views/signin_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return SignInScreen(
        onTap: togglePages,
      );
    } else{
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
