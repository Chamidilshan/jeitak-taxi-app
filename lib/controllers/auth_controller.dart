import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:jeitak_app/models/user_model.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:jeitak_app/views/home_page.dart';
import 'package:jeitak_app/views/profile_setting_screen.dart';
import 'package:path/path.dart' as Path;
import 'package:geocoding/geocoding.dart' as geoCoding;

class AuthController extends GetxController{

  var isDecided = false;
  var isProfileUploading = false.obs;
  TextEditingController controller = TextEditingController();
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

  var myUser = UserModel().obs;

  storeUserInfo(
      File? selectedImage,
      String name,
      String home,
      String business,
      String shop ,
      {
        String url = '',
        LatLng? homeLatLng,
        LatLng? businessLatLng,
        LatLng? shoppingLatLng,
      }
      ) async {
    //String url = await uploadImage(selectedImage!);
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
      'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      'business_latlng':
      GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
      'shopping_latlng':
      GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.to(() => HomeScreen());
    });
  }


  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }

  // Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
  //   Prediction? p = await PlacesAutocomplete.show(
  //     offset: 0,
  //     radius: 1000,
  //     strictbounds: false,
  //     region: "pk",
  //     language: "en",
  //     context: context,
  //     mode: Mode.overlay,
  //     apiKey: AppConstants.kGoogleApiKey,
  //     components: [new Component(Component.country, "pk")],
  //     types: [],
  //     hint: "Search City",
  //   );
  //
  //   return p;
  // }
  //
  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations =
    await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<String?> openGoogleAutoCompleteTextField(BuildContext context) async {
    String? selectedLocation = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                GooglePlaceAutoCompleteTextField(
                  textEditingController: TextEditingController(),
                  googleAPIKey: "AIzaSyAvgoLt-borSsoJ4NTTHFnDjcOLAr84i2k",
                  debounceTime: 800,
                  countries: ["in", "fr"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    print("placeDetails " + prediction.lat.toString());
                    print("placeDetails " + prediction.lng.toString());
                  },
                  itemClick: (Prediction prediction) {
                    Navigator.pop(context, prediction.description);
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 7),
                          Expanded(child: Text("${prediction.description ?? ""}")),
                        ],
                      ),
                    );
                  },
                  isCrossBtnShown: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor
                  ),
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );

    return selectedLocation;
  }



}