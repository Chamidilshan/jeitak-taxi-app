import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:jeitak_app/controllers/auth_controller.dart';
import 'package:jeitak_app/controllers/polylyne_handler.dart';
import 'package:jeitak_app/utils/colors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:jeitak_app/views/my_profile_screen.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:jeitak_app/views/payment_screen.dart';
import 'dart:ui' as ui;

import 'package:jeitak_app/widgets/text_widget.dart';

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
  final TextEditingController fromController = TextEditingController();
  bool showPlaceAutoCompleteNew = false;

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};
  Set<Marker> markers = Set<Marker>();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  String dropdownValue = '**** **** **** 8789';

  @override
  void initState() {
    super.initState();
    authController.getUserInfo();
    rootBundle.loadString('assets/map_styles.txt').then((string) {
      _mapStyle = string;
    });
    loadCustomMarker();
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signOutUser,
              icon: Icon(Icons.logout)
          )
        ],
        title: Text('Logged in as ' + user.email!),
        backgroundColor: AppColors.mainColor
        ,
        elevation: 0,
      ),
      drawer: buildDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              // mapType: MapType.terrain,
              zoomControlsEnabled: false,
              polylines: polyline,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
                // _controller.complete(controller);
              },
              initialCameraPosition: _kGooglePlex,
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
      Obx(() =>
      authController.myUser.value.name == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          :
      Container(
        width: Get.width,
        //height: Get.width * 0.5,
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
                  authController.myUser.value.image == null
                      ?
                  DecorationImage(
                      image: AssetImage('assets/person.png'),
                      fit: BoxFit.fill)
                      : DecorationImage(
                      image: NetworkImage(
                          authController.myUser.value.image!),
                      fit: BoxFit.fill)
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
                        text: 'Good day, ',
                        style:
                        TextStyle(color: Colors.black, fontSize: 14)),
                    TextSpan(
                        text: authController.myUser.value.name,
                        // text: 'Mark',
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
      ),
    );
  }

  bool showSourceField = false;
  TextEditingController sourceController = TextEditingController();

  Widget buildTextField() {
    return Positioned(
      top: 100.0,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Search a location',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold
            ),
          ),
          Container(
            width: Get.width,
            height: 60,
            padding: EdgeInsets.only(left: 0.0),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 4,
                      blurRadius: 1)
                ],
                borderRadius: BorderRadius.circular(8)),
            child: GestureDetector(
              onTap: (){},
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "AIzaSyAvgoLt-borSsoJ4NTTHFnDjcOLAr84i2k",
                debounceTime: 800,
                countries: ["in", "fr", "lk", "us", "sa"],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  print("placeDetails " + prediction.lng.toString());
                  setState(() {
                    showSourceField = true;
                  });
                },
                itemClick: (Prediction prediction) async {
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length),
                  );

                  //  String selectedPlace = p!.description!;
                  // //
                  // geoCoding.Location selectedPlace = controller.text;

                  List<geoCoding.Location> locations =
                  await geoCoding.locationFromAddress(controller.text);

                  destination =
                      LatLng(locations.first.latitude, locations.first.longitude);

                  markers.add(Marker(
                    markerId: MarkerId(controller.text),
                    infoWindow: InfoWindow(
                      title: 'Destination: $controller.text',
                    ),
                    position: destination,
                    icon: BitmapDescriptor.fromBytes(markIcons),
                  ));

                  myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: destination, zoom: 14)
                    //17 is new zoom level
                  ));


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
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 200.0,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location to start',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold
            ),
          ),
          Container(
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
        ],
      ),
    );
  }
  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: AppColors.mainColor,
                  shape: StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  int selectedRide = 0;

  buildDriversList() {
    return Container(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? AppColors.mainColor : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '\$9.90',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/Mask Group 2.png'))
        ],
      ),
    );
  }

  Widget buildTextFieldForNewSource() {
    return Positioned(
      top: 230,
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
          textEditingController: fromController,
          googleAPIKey: "AIzaSyAvgoLt-borSsoJ4NTTHFnDjcOLAr84i2k",
          debounceTime: 800,
          countries: ["in", "fr", "sa", "lk"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails " + prediction.lng.toString());
            setState(() {
              showSourceField = true;
            });
          },
          itemClick: (Prediction prediction) async{
            fromController.text = prediction.description ?? "";
            fromController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length),
            );

            //  String selectedPlace = p!.description!;
            // //
            // geoCoding.Location selectedPlace = controller.text;

            List<geoCoding.Location> locations =
            await geoCoding.locationFromAddress(fromController.text);

            source  =
                LatLng(locations.first.latitude, locations.first.longitude);

            if(markers.length>=2){
              markers.remove(markers.last);
            }

            markers.add(Marker(
              markerId: MarkerId(fromController.text),
              infoWindow: InfoWindow(
                title: 'Destination: $fromController.text',
              ),
              position: source,
              icon: BitmapDescriptor.fromBytes(markIcons),
            ));

            drawPolyline(fromController.text);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14)
              //17 is new zoom level
            ));


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

  void drawPolyline(String placeId) {
    _polyline.clear();
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: AppColors.mainColor,
      width: 5,
    ));
  }

  void  buildSourceSheet() {
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
              Get.back();
              source = authController.myUser.value.homeAddress!;
              sourceController.text = authController.myUser.value.hAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.hAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.hAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);
              print('');
              print('');
              print('');
              print('');
              print(source);
              print('');
              print('');
              print('');
              print('');
              print(destination);

              // drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});

              buildRideConfirmationSheet();
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
                    authController.myUser.value.hAddress!,
                    //'London',
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
              source = authController.myUser.value.bussinessAddres!;
              sourceController.text = authController.myUser.value.bAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.bAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.bAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);
              print('');
              print('');
              print('');
              print('');
              print(source);
               print('');
               print('');
               print('');
               print('');
              print(destination);

              // drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});

              buildRideConfirmationSheet();
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
                    authController.myUser.value.bAddress!,
                    // 'New York',
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
              Get.back();
              String? location = await authController.openGoogleAutoCompleteTextField(context);
              source = await authController.buildLatLngFromAddress(location.toString());
              sourceController.text = location.toString();

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(sourceController.text),
                  infoWindow: InfoWindow(
                    title: 'Source: ${sourceController.text}',
                  ),
                  position: source));

              await getPolylines(source, destination);
              print('');
              print('');
              print('');
              print('');
              print(source);
              print('');
              print('');
              print('');
              print('');
              print(destination);

              // drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});

              buildRideConfirmationSheet();
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

  Future<LatLng?> showGoogleAutoComplete() {
    final completer = Completer<LatLng?>();

    GooglePlaceAutoCompleteTextField(
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
        completer.complete(LatLng(prediction.lat as double, prediction.lng as double));
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
    );

    return completer.future;
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

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const MyProfileScreen());
            },
            child: SizedBox(
              height: 150,
              child: DrawerHeader(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                            authController.myUser.value.image == null
                                ?
                            const DecorationImage(
                                image: AssetImage('assets/person.png'),
                                fit: BoxFit.fill)
                                : DecorationImage(
                                image: NetworkImage(
                                   authController.myUser.value.image!),
                                fit: BoxFit.fill)
              ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Good Morning, ',
                                style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.28),
                                    fontSize: 14)
                        ),
                            Text(
                              authController.myUser.value.name == null
                                  ?
                              "User"
                                  : authController.myUser.value.name!,
                              style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(title: 'Payment History', onPressed: ()  {
                  Get.to(()=> PaymentScreen());
    }

                ),
                buildDrawerItem(
                    title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                buildDrawerItem(title: 'Settings', onPressed: () {}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(title: 'Log Out', onPressed: () {

                  FirebaseAuth.instance.signOut();
                  signOutUser();
                }),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.15),
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  late Uint8List markIcons;

  loadCustomMarker() async {
    markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  buildDrawerItem(
      {required String title,
        required Function onPressed,
        Color color = Colors.black,
        double fontSize = 20,
        FontWeight fontWeight = FontWeight.w700,
        double height = 45,
        bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
              backgroundColor: AppColors.mainColor,
              radius: 15,
              child: Text(
                '1',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }

}

