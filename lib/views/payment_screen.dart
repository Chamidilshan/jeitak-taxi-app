import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeitak_app/controllers/auth_controller.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/views/add_payment_card_page.dart';
import 'package:jeitak_app/widgets/green_into_widget.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentScreenState();
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '5555 55555 5555 4444';
  String expiryDate = '12/25';
  String cardHolderName = 'Osama Qureshi';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthController authController = Get.find<AuthController>();


  @override
  void initState() {

    //authController.getUserCards();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: <Widget>[

            greenIntroWidgetWithoutLogos(title: 'My Card'),


            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 80,
              child: ListView.builder(

                shrinkWrap: true,
                itemBuilder: (ctx,i) {

                  String cardNumber = '';
                  String expiryDate = '';
                  String cardHolderName = '';
                  String cvvCode = '';

                  // try{
                  //   cardNumber = authController.userCards.value[i].get('number');
                  // }catch(e){
                  //   cardNumber = '';
                  // }
                  //
                  // try{
                  //   expiryDate = authController.userCards.value[i].get('expiry');
                  // }catch(e){
                  //   expiryDate = '';
                  // }
                  //
                  // try{
                  //   cardHolderName = authController.userCards.value[i].get('name');
                  // }catch(e){
                  //   cardHolderName = '';
                  // }
                  //
                  // try{
                  //   cvvCode = authController.userCards.value[i].get('cvv');
                  // }catch(e){
                  //   cvvCode = '';
                  // }

                  return CreditCardWidget(
                    cardBgColor: Colors.black,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    bankName: '',
                    showBackView: isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},

                  );
                },
                itemCount: 4
                //authController.userCards.length,
              )
            ),

            Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Add new card",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold,color: AppColors.mainColor),),

                    SizedBox(width: 10,),

                    FloatingActionButton(onPressed: (){


                      Get.to(()=> AddNewCardScreen());

                    },child: Icon(Icons.arrow_forward,color: Colors.white,),backgroundColor: AppColors.mainColor,)
                  ],
                ))


          ],
        ),
      ),
    );
  }


}