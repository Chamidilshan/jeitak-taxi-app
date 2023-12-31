import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/views/my_profile_screen.dart';
import 'package:jeitak_app/views/profile_setting_screen.dart';
import 'package:jeitak_app/widgets/custom_radio.dart';
import 'package:jeitak_app/widgets/gender_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);



  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailControlller = TextEditingController();
  final _passwordControlller = TextEditingController();
  final _confirmPasswordControlller = TextEditingController();
  final _fullNameControlller = TextEditingController();

  List<Gender> genders = [];


  void signUserUp() async{

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

      if(_passwordControlller.text == _confirmPasswordControlller.text){
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailControlller.text,
            password: _passwordControlller.text
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyProfileScreen())
        );
        print('');
        print('');
        print('');
        print('');
        print('');
        print('');


      } else{
        showDialog(
            context: context,
            builder: (context){
              Navigator.pop(context);
              return AlertDialog(
                title: Text('Passwords not match'),
              );
            }
        );
      }

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
  void initState() {
    super.initState();
    genders.add(new Gender("Male", MdiIcons.genderMale, false));
    genders.add(new Gender("Female", MdiIcons.genderFemale, false));
    //genders.add(new Gender("Others", MdiIcons.genderTransgender, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sign up", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 20,),
                  Text("Create an account, It's free", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),),
                ],
              ),
              Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Full Name', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87
                      ),),
                      SizedBox(height: 5,),
                      TextField(
                        obscureText: false,
                        controller: _fullNameControlller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Email', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87
                  ),),
                  SizedBox(height: 5,),
                  TextField(
                    obscureText: false,
                    controller: _emailControlller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Gender', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87
                  ),),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                height: 100.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: genders.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: AppColors.mainColor.withOpacity(0.8),
                        onTap: () {
                          setState(() {
                            genders.forEach((gender) => gender.isSelected = false);
                            genders[index].isSelected = true;
                          });
                        },
                        child: CustomRadio(genders[index]),
                      );
                    }),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Password', style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87
              ),),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                controller: _passwordControlller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Confirm Password', style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87
              ),),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                controller: _confirmPasswordControlller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
                ],
              ),
               Container(
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
                    signUserUp();
                  },
                  color: AppColors.mainColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text("Sign up", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                  ),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  Text(" Login", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18
                  ),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }

}
