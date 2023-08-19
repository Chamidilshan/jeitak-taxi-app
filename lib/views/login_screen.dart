// import 'package:fl_country_code_picker/fl_country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:jeitak_app/utils/colors.dart';
// import 'package:jeitak_app/views/otp_verification_screen.dart';
// import 'package:jeitak_app/widgets/green_into_widget.dart';
//
// import '../widgets/login_widget.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   @override
//   void initState(){
//     super.initState();
//     // if(MediaQuery.of(context).viewInsets.bottom > 0){
//     //   FocusManager.instance.primaryFocus?.unfocus();
//     // }
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//   }
//
//   final countryPicker = const FlCountryCodePicker();
//
//   CountryCode countryCode = CountryCode(name: 'United States', code: "US", dialCode: "+1");
//
//
//   onSubmit(String? input){
//     Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: (){
//           FocusScope.of(context).unfocus();
//         },
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 Stack(
//                   children: [
//                     greenIntroWidget(),
//                     Positioned(
//                       top: 60.0,
//                       left: 20.0,
//                       child: InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: Container(
//                           width: 45.0,
//                           height: 45.0,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle
//                           ),
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: AppColors.mainColor,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//
//                 const SizedBox(height: 50,),
//
//                 loginWidget( countryCode,()async{
//                   final code = await countryPicker.showPicker(context: context);
//                   if (code != null)  countryCode = code;
//                   setState(() {
//
//                   });
//                 },onSubmit),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
