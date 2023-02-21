// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Preferences/preferences.dart';
import 'package:smartblood/Screens/loginscreen.dart';
import 'package:smartblood/firebaseinstances/instance.dart';

class ProfileScreen extends StatefulWidget {
  String? primaryKey;
  ProfileScreen(this.primaryKey, {Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Register profileDetails = Register();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Instances.userInstance
              .where('mobile', isEqualTo: widget.primaryKey.toString())
              .snapshots(),
          builder: (context, profilesnapshot) {
            if (profilesnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (profilesnapshot.hasData) {
              var data = profilesnapshot.data!.docs;
              if (data.isEmpty) {
                return Center(child: Text("No Data Found !!"));
              } else {
                profileDetails = Register(
                    name: data[0]["name"],
                    email: data[0]["email"],
                    mobile: data[0]["mobile"],
                    bloodgroup: data[0]["bloodgroup"],
                    superuser: data[0]["superuser"],
                    rewardpoints: data[0]["rewardpoints"]);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 19.0),
                    child: Column(children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF787EFF),
                        radius: 70,
                        child: Text(
                          profileDetails.name.toString()[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 81, color: Colors.white),
                        ), //Text
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profileDetails.name.toString(),
                            style: TextStyle(fontSize: 23.0),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          profileDetails.superuser.toString() == "no"
                              ? Container()
                              : Icon(
                                  Icons.check_circle_rounded,
                                  color: Color.fromARGB(255, 50, 39, 176),
                                  size: 20,
                                ),
                        ],
                      ), //Circl
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 19.0, left: 24.0, right: 24.0),
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            constraints:
                                BoxConstraints(maxHeight: double.infinity),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF787EFF), //New
                                )
                              ], //Border.all
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 9.0, top: 9.0),
                                  child: Text(
                                    "Account Details",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: const Color(0xFF6D6D6D),
                                        letterSpacing: 0.44),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 9.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/svg/email.svg"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Email",
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                        color: const Color(
                                                            0xFF6D6D6D),
                                                        letterSpacing: 0.44)),
                                                Text(
                                                    profileDetails.email
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        letterSpacing: 0.44))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 9.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/svg/phone.svg"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Mobile",
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color: const Color(
                                                            0xFF6D6D6D),
                                                        letterSpacing: 0.44)),
                                                Text(
                                                    profileDetails.mobile
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        letterSpacing: 0.44))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                "assets/png/blooddrop.png",
                                                width: 20,
                                                height: 20),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Blood Group",
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                        color: const Color(
                                                            0xFF6D6D6D),
                                                        letterSpacing: 0.44)),
                                                Text(
                                                    profileDetails.bloodgroup
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        letterSpacing: 0.44))
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 24.0, right: 24.0),
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            constraints:
                                BoxConstraints(maxHeight: double.infinity),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF787EFF), //New
                                )
                              ], //Border.all
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/png/badge.png"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Reward Points",
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              color: const Color(0xFF6D6D6D),
                                              letterSpacing: 0.44)),
                                      Text(
                                          profileDetails.rewardpoints
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 23,
                                              color: Colors.black,
                                              letterSpacing: 0.44))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 24.0, right: 24.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await Preferences.preference();
                            sharedPreferences.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (Route route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(35), //
                              primary: const Color(0xFF787EFF),
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          child: Text(
                            'LOGOUT',
                            style: GoogleFonts.notoSans(
                                fontSize: 23.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }
            } else {
              return Center(child: Text("No Profile Data Found !!!"));
            }
            return Center(child: Text("Error Occured !!"));
          }),
    ));
  }
}
