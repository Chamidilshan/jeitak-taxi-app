import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeitak_app/controllers/auth_controller.dart';
import 'package:jeitak_app/utils/colors.dart';

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
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
                // _controller.complete(controller);
              }, initialCameraPosition: _kGooglePlex,
            ),
          ),

          buildProfileTile(),

          buildTextField()
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

  Widget buildTextField(){
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
        child: TextFormField(
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
    );
  }

}

