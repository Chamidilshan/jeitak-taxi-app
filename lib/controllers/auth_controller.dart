import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeitak_app/views/home_page.dart';
import 'package:jeitak_app/views/profile_setting_screen.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController{

  var isDecided = false;
  var isProfileUploading = false.obs;
  // var myUser = UserModel().obs;


  decideRoute() {
    if (isDecided) {
      return;
    }
    isDecided = true;
    print("called");

    ///step 1- Check user login?
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      /// step 2- Check whether user profile exists?

      ///isLoginAsDriver == true means navigate it to the driver module

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {


        ///isLoginAsDriver == true means navigate it to driver module

        // if(isLoginAsDriver){
        //
        //   if (value.exists) {
        //     print("Driver HOme Screen");
        //   } else {
        //     Get.offAll(() => DriverProfileSetup());
        //   }


        //}else
        //{
          if (value.exists) {
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => ProfileScreen());
          }
        //}



      }).catchError((e) {
        print("Error while decideRoute is $e");
      });
    }
  }


  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance
        .ref()
        .child('users/$fileName'); // Modify this path/string as your need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
          (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
  }

  storeUserInfo(
      File? selectedImage,
      String name,
      String home,
      String business,
      String shop ,
      // {
      //   String url = '',
      //   // LatLng? homeLatLng,
      //   // LatLng? businessLatLng,
      //   // LatLng? shoppingLatLng,
      // }
      ) async {
    String url = await uploadImage(selectedImage!);
    // String url_new = url;
    // if (selectedImage != null) {
    //   url_new = await uploadImage(selectedImage);
    // }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
      // 'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      // 'business_latlng':
      // GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
      // 'shopping_latlng':
      // GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.to(() => HomeScreen());
    });
  }



}