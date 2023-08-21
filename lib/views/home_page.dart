import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:jeitak_app/controllers/auth_controller.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_places_flutter/google_places_flutter.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  AuthController authController = Get.find<AuthController>();
  String? _mapStyle;
  GoogleMapController? myMapController;
  final TextEditingController controller = TextEditingController();

  final  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_styles.txt').then((string) {
      _mapStyle = string;
    });
  }

  void signOutUser(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: signOutUser,
      //         icon: Icon(Icons.logout)
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 150.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              // mapType: MapType.terrain,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
                // _controller.complete(controller);
              }, initialCameraPosition: _kGooglePlex,
            ),
          ),

          buildProfileTile(),

          buildTextField(),


          showSourceField ? buildTextFieldForSource() : Container(),

          buildCurrentLocationIcon(),

          buildNotificationIcon(),

          buildBottomSheet()
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child:
      // Obx(() => authController.myUser.value.name == null
      //     ? Center(
      //   child: CircularProgressIndicator(),
      // )
      //     :
      Container(
        width: Get.width,
        height: Get.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: Colors.white70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                  //authController.myUser.value.image == null
                      //?
                  DecorationImage(
                      image: AssetImage('assets/person.png'),
                      fit: BoxFit.fill)
                      // : DecorationImage(
                      // image: NetworkImage(
                      //     authController.myUser.value.image!),
                      // fit: BoxFit.fill)
                ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Good Morning, ',
                        style:
                        TextStyle(color: Colors.black, fontSize: 14)),
                    TextSpan(
                        //text: authController.myUser.value.name,
                      text: 'Mark',
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ]),
                ),
                Text(
                  "Where are you going?",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            )
          ],
        ),
      )
    //),
    );
  }

  bool showSourceField = false;
  TextEditingController sourceController = TextEditingController();

  Widget buildTextField() {
    return Positioned(
      top: 170.0,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "AIzaSyAvgoLt-borSsoJ4NTTHFnDjcOLAr84i2k",
          debounceTime: 800,
          countries: ["in", "fr"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails " + prediction.lng.toString());
            setState(() {
              showSourceField = true;
            });
          },
          itemClick: (Prediction prediction) {
            controller.text = prediction.description ?? "";
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length),
            );
            setState(() {
              showSourceField = true;
            });
          },
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(child: Text("${prediction.description ?? ""}")),
                ],
              ),
            );
          },
          isCrossBtnShown: true,
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {
            buildSourceSheet();
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'From:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void buildSourceSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Select Your Location",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Home Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              // Get.back();
              // source = authController.myUser.value.homeAddress!;
              // sourceController.text = authController.myUser.value.hAddress!;
              //
              // if (markers.length >= 2) {
              //   markers.remove(markers.last);
              // }
              // markers.add(Marker(
              //     markerId: MarkerId(authController.myUser.value.hAddress!),
              //     infoWindow: InfoWindow(
              //       title: 'Source: ${authController.myUser.value.hAddress!}',
              //     ),
              //     position: source));
              //
              // await getPolylines(source, destination);
              //
              // // drawPolyline(place);
              //
              // myMapController!.animateCamera(CameraUpdate.newCameraPosition(
              //     CameraPosition(target: source, zoom: 14)));
              // setState(() {});
              //
              // buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    //authController.myUser.value.hAddress!,
                    'London',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Business Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
               Get.back();
              // source = authController.myUser.value.bussinessAddres!;
              // sourceController.text = authController.myUser.value.bAddress!;
              //
              // if (markers.length >= 2) {
              //   markers.remove(markers.last);
              // }
              // markers.add(Marker(
              //     markerId: MarkerId(authController.myUser.value.bAddress!),
              //     infoWindow: InfoWindow(
              //       title: 'Source: ${authController.myUser.value.bAddress!}',
              //     ),
              //     position: source));
              //
              // await getPolylines(source, destination);
              //
              // // drawPolyline(place);
              //
              // myMapController!.animateCamera(CameraUpdate.newCameraPosition(
              //     CameraPosition(target: source, zoom: 14)));
              // setState(() {});
              //
              // buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    //authController.myUser.value.bAddress!,
                    'New York',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              // Get.back();
              // Prediction? p =
              // await authController.showGoogleAutoComplete(context);
              //
              // String place = p!.description!;
              //
              // sourceController.text = place;
              //
              // source = await authController.buildLatLngFromAddress(place);
              //
              // if (markers.length >= 2) {
              //   markers.remove(markers.last);
              // }
              // markers.add(Marker(
              //     markerId: MarkerId(place),
              //     infoWindow: InfoWindow(
              //       title: 'Source: $place',
              //     ),
              //     position: source));
              //
              // await getPolylines(source, destination);
              //
              // // drawPolyline(place);
              //
              // myMapController!.animateCamera(CameraUpdate.newCameraPosition(
              //     CameraPosition(target: source, zoom: 14)));
              // setState(() {});
              // buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search for Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }


  Widget buildTextNormalField(){
    return Positioned(
      top: 170.0,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              readOnly: true,
              onTap: (){
                showGoogleAutoComplete();
              },
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffA7A7A7)
              ),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                  ),
                ),
                hintText: 'Search for a destination',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
                contentPadding: EdgeInsets.only(left: 20.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<GooglePlaceAutoCompleteTextField> showGoogleAutoComplete() async{
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: "YOUR_GOOGLE_API_KEY",
      debounceTime: 800,
      countries: ["in", "fr"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        print("placeDetails " + prediction.lat.toString());
        print("placeDetails " + prediction.lng.toString());
      },
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? "";
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
      },
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(
                width: 7,
              ),
              Expanded(child: Text("${prediction.description ?? ""}")),
            ],
          ),
        );
      },
      //separatedBuilder: Divider(),
      isCrossBtnShown: true,
    );
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.mainColor,
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.notifications,
            color: Color(0xffC3CDD6),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 25,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

}

