// ignore_for_file: prefer_const_constructors, must_be_immutable, non_constant_identifier_names, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:smartblood/Apiservices/apirepo.dart';
import 'package:smartblood/Model/mapmodel/mapmodel.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Screens/searchscreen.dart';
import 'package:smartblood/Screens/userdetails.dart';
import 'package:smartblood/firebase/backend/backend.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:intl/intl.dart';
import 'package:smartblood/services/service.dart';
import 'package:smartblood/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  String phone;
  MainScreen(this.phone, {Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List bloodGroups = ["All", "O+", "B+", "O-", "AB+", "AB-", "B-", "A+", "A-"];
  int filterIndex = 0;
  List<Mapdata> cities = [];
  bool filtersDisplay = true;
  bool filterstatus = false;
  String? _currentAddress;
  Position? _currentPosition;
  bool checkPermission = false;
  bool checkLocation = false;
  @override
  void initState() {
    getdata();
    getToken();
    getCurrentPosition();
    super.initState();
  }

  getdata() async {
    ApiRepository apiRepository = ApiRepository();
    List<Mapdata> data = await apiRepository.fetchData();
    data.sort(
      (a, b) => a.city!.compareTo(b.city!),
    );
    setState(() {
      cities = data;
    });
  }

  getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print(fcmToken);
    }
  }
  Future<void> getCurrentPosition() async {
    final hasPermission = await Service.handleLocationPermission(context);
    setState(() {
      checkPermission = hasPermission;
    });

    if (!hasPermission) {
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      return e;
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        checkLocation = true;
        _currentAddress =
            '${place.subLocality} , ${place.subAdministrativeArea} , ${place.postalCode}';
             Fetch.updateLocationfirebase(widget.phone,_currentAddress.toString(),_currentPosition!.latitude,_currentPosition!.longitude,context);
        if (kDebugMode) {
          print(_currentPosition!.latitude);
        }
        if (kDebugMode) {
          print(_currentPosition!.longitude);
        }
        if (kDebugMode) {
          print(_currentAddress);
        }
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: Instances.userInstance
              .where("mobile", isEqualTo: widget.phone)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Container());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                "Error Occured !",
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                ),
              ));
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Data Not Found !!!"));
              } else {
                var data = snapshot.data!.docs[0];

                Register PersonalData = Register(
                    name: data["name"],
                    location: data["location"],
                    mobile: data["mobile"],
                    superuser: data['superuser'],
                    bloodgroup: data['bloodgroup'],
                    lat: data['lat'],
                    long: data['long'],
                    mtoken: data['mtoken'],
                    isdonated: data['isdonated']
                  );
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 156, 161, 249)
                              .withOpacity(0.3)),
                      height: 128,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, top: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hi",
                                      style: GoogleFonts.roboto(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF6D6D6D),
                                          letterSpacing: 0.44),
                                    ),
                                    Text(
                                      PersonalData.name.toString(),
                                      style: GoogleFonts.philosopher(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF000000),
                                          letterSpacing: 0.44),
                                    ),
                                  ],
                                ),
                                PersonalData.location!.isEmpty?Container():FloatingActionButton(
                                  backgroundColor: Color.fromARGB(255, 156, 161, 249),
                                  onPressed: (){
                                   MapsLauncher.launchQuery('Nearest Hospitals in ${PersonalData.location!}');
                                },child: Icon(Icons.map_sharp),)
                              ],
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                            cities, widget.phone)));
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/svg/location.svg"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    PersonalData.location!.isEmpty
                                        ? "Select Location"
                                        : PersonalData.location.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF000000),
                                        letterSpacing: 0.44,
                                        fontStyle: FontStyle.normal),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: Instances.userInstance
                            .where("mobile", isNotEqualTo: widget.phone)
                            .where("location", isEqualTo: PersonalData.location)
                            .snapshots(),
                        builder: (context, filtersnapshot) {
                          if (filtersnapshot.hasData) {
                            if (filtersnapshot.data!.docs.isEmpty ||
                                PersonalData.location!.isEmpty) {
                              return Container();
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0,
                                      top: 13.0,
                                      right: 18.0,
                                      bottom: 18.0),
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i < bloodGroups.length;
                                          i++)
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  filterIndex = i;
                                                  filterstatus = true;
                                                });
                                              },
                                              child: Container(
                                                  width: 49,
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 156, 161, 249),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    bloodGroups[i].toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: 0.44,
                                                        color: filterIndex == i
                                                            ? Colors.white
                                                            : Colors.black),
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 18,
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Container();
                          }
                        }),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: bloodGroups[filterIndex] == "All"
                              ? Instances.userInstance
                                  .where("mobile", isNotEqualTo: widget.phone)
                                  .where("location",
                                      isEqualTo: PersonalData.location)
                                  .snapshots()
                              : Instances.userInstance
                                  .where("mobile", isNotEqualTo: widget.phone)
                                  .where("location",
                                      isEqualTo: PersonalData.location)
                                  .where("bloodgroup",
                                      isEqualTo: bloodGroups[filterIndex])
                                  .snapshots(),
                          builder: (context, usersnapshot) {
                            if (usersnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (usersnapshot.connectionState ==
                                    ConnectionState.done ||
                                usersnapshot.connectionState ==
                                    ConnectionState.active) {
                              if (usersnapshot.hasError) {
                                return Text("Error Occured !! ");
                              } else if (usersnapshot.hasData) {
                                if (PersonalData.location!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "Please Select Your Location to start",
                                      style: GoogleFonts.notoSans(
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                } else if (usersnapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/png/empty.png"),
                                      Text(
                                        filterstatus == true &&
                                                usersnapshot
                                                    .data!.docs.isEmpty &&
                                                bloodGroups[filterIndex] !=
                                                    "All"
                                            ? "No Users Found in ${PersonalData.location}\nwith this ${bloodGroups[filterIndex]} Group."
                                            : "No Users Found in ${PersonalData.location}",
                                        style: GoogleFonts.notoSans(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ));
                                } else {
                                  return ListView.builder(
                                      itemCount: usersnapshot.data!.docs.length,
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var userData =
                                            usersnapshot.data!.docs[index];
                                        Register register = Register(
                                            name: userData["name"],
                                            mobile: userData["mobile"],
                                            bloodgroup: userData["bloodgroup"],
                                            superuser: userData["superuser"],
                                            location: userData['location'],
                                            gender: userData['gender'],
                                            state: userData['state'],
                                            lat: userData['lat'],
                                            long: userData['long'],
                                            mtoken: userData['mtoken'],
                                            isdonated: userData['isdonated'],
                                            rewardpoints:
                                                userData['rewardpoints'],
                                            donateddate:
                                                userData['donateddate']);
                                        return InkWell(
                                          onTap: () async {
                                            if (register.isdonated==true) {
                                              DateTime tsdate = DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      register.donateddate!
                                                          .millisecondsSinceEpoch);
                                              String datetime =
                                                  "${tsdate.year}-${tsdate.month}-${tsdate.day}";
                                              DateTime dt1 =
                                                  DateTime.parse(datetime);

                                              DateTime dt4 = dt1
                                                  .add(Duration(hours: 2190));

                                              String datetime1 =
                                                  DateFormat("dd MMM yyyy")
                                                      .format(dt4);
                                              AllWidgets.toast("User Already Donated Blood he will be Avail on $datetime1");
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserDetails(
                                                              register,
                                                              PersonalData,
                                                              cities,
                                                              PersonalData
                                                                  .mobile)));
                                            }
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  top: 12.0,
                                                  right: 18.0,
                                                  bottom: 6.0),
                                              child: Material(
                                                elevation: 10,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          double.infinity),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 4.0,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            5)), //Border.all
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 5.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              child:
                                                                  Image.asset(

                                                                "assets/png/user.png",
                                                                width: 70,
                                                                height: 70,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      top: 5.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    userData[
                                                                            "name"]
                                                                        .toString(),
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Color(
                                                                            0xFF787EFF),
                                                                        letterSpacing:
                                                                            0.44),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  register.superuser ==
                                                                          "no"
                                                                      ? Container()
                                                                      : Icon(
                                                                          Icons
                                                                              .check_circle_rounded,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              50,
                                                                              39,
                                                                              176),
                                                                          size:
                                                                              20,
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 10.0,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            219,
                                                                            221,
                                                                            254),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            "assets/svg/location_s.svg",
                                                                            width:
                                                                                15,
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            register.location!.isEmpty
                                                                                ? "Not Found"
                                                                                : register.location.toString(),
                                                                            style: GoogleFonts.roboto(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: const Color(0xFF000000),
                                                                                letterSpacing: 0.44,
                                                                                fontStyle: FontStyle.normal),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  register
                                                                      .bloodgroup
                                                                      .toString()
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      color: Color(
                                                                          0xFF787EFF)),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        );
                                      });
                                }
                              }
                            } else {
                              return Text('${snapshot.connectionState}');
                            }
                            return Container();
                          }),
                    )
                    //  TextButton(onPressed: (){
                    //   MapsLauncher.launchQuery('Nearest Hospitals in Tadepalligudem');
                    //  }, child: Text("Open Maps"))
                  ],
                );
              }
            }
          }),
    );
  }
}
