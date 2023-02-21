// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_const_constructors, unused_element, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_badged/flutter_badge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartblood/Screens/mainscreen.dart';
import 'package:smartblood/Screens/notifications.dart';
import 'package:smartblood/Screens/profilescreen.dart';
import 'package:smartblood/Screens/requestscreen.dart';
import 'package:badges/badges.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/services/pushservice.dart';
import 'package:smartblood/services/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mobilenumber;
  late bool check;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    check = false;
    localStorage();
    LocalNotificationService localNotificationService =
        LocalNotificationService();
    localNotificationService.initialize();
    LocalNotificationService.requestPermission();
    localNotificationService.loadFCM();
    localNotificationService.display();
  }

  Future<void> localStorage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      mobilenumber = sharedPreferences.getString('mobile').toString();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      MainScreen(mobilenumber.toString()),
      RequestScreen(mobilenumber.toString()),
      NotificationsScreen(mobilenumber.toString()),
      ProfileScreen(mobilenumber)
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFF7E82DF).withOpacity(0.3),
        statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: screens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    selectedIndex == 0
                        ? 'assets/svg/home_s.svg'
                        : 'assets/svg/home.svg',
                    color:
                        selectedIndex == 0 ? Color(0xFF787EFF) : Colors.black,
                  ),
                  label: 'home',
                ),
                BottomNavigationBarItem(
                  icon: StreamBuilder<DocumentSnapshot>(
                      stream: Instances.receivedInstance
                          .doc(mobilenumber.toString())
                          .snapshots(),
                      builder: (context, countsnapshot) {
                        if (countsnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SvgPicture.asset(
                            selectedIndex == 1
                                ? 'assets/svg/document_s.svg'
                                : 'assets/svg/document.svg',
                            color: selectedIndex == 1
                                ? Color(0xFF787EFF)
                                : Colors.black,
                          );
                        } else if (countsnapshot.connectionState ==
                                ConnectionState.done ||
                            countsnapshot.connectionState ==
                                ConnectionState.active) {
                          if (countsnapshot.hasError) {
                            return const Text("Error Occured !! ");
                          } else if (countsnapshot.hasData &&
                              countsnapshot.data!.exists == true) {
                            Map<String, dynamic> res = countsnapshot.data!
                                .data() as Map<String, dynamic>;
                            List count = res["received"];
                            List pendingcount = count
                                .where(
                                    (element) => element["isdonated"] == false)
                                .toList();
                            return Badge(
                              badgeStyle: BadgeStyle(
                                badgeColor: Color(0xFF787EFF),
                              ),
                              badgeContent: Text(
                                pendingcount.length.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: SvgPicture.asset(
                                selectedIndex == 1
                                    ? 'assets/svg/document_s.svg'
                                    : 'assets/svg/document.svg',
                                color: selectedIndex == 1
                                    ? Color(0xFF787EFF)
                                    : Colors.black,
                              ),
                            );
                          } else {
                            return Badge(
                              badgeStyle: BadgeStyle(
                                badgeColor: Color(0xFF787EFF),
                              ),
                              badgeContent: Text(
                                "0".toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: SvgPicture.asset(
                                selectedIndex == 1
                                    ? 'assets/svg/document_s.svg'
                                    : 'assets/svg/document.svg',
                                color: selectedIndex == 1
                                    ? Color(0xFF787EFF)
                                    : Colors.black,
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      }),
                  label: 'requests',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    selectedIndex == 2
                        ? 'assets/svg/notifications_s.svg'
                        : 'assets/svg/notifications.svg',
                    color:
                        selectedIndex == 2 ? Color(0xFF787EFF) : Colors.black,
                  ),
                  label: 'notifications',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    selectedIndex == 3
                        ? 'assets/svg/profile_s.svg'
                        : 'assets/svg/profile.svg',
                    color:
                        selectedIndex == 3 ? Color(0xFF787EFF) : Colors.black,
                  ),
                  label: 'profile',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              selectedItemColor: const Color(0xFF787EFF),
              onTap: _onItemTapped,
              elevation: 10),
        ),
      ),
    );
  }
}
