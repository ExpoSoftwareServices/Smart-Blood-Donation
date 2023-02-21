// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartblood/Screens/homescreen.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/widgets/widgets.dart';

class SkipScreen extends StatefulWidget {
  SkipScreen(this.mobile, {super.key});
  String mobile;

  @override
  State<SkipScreen> createState() => _SkipScreenState();
}

class _SkipScreenState extends State<SkipScreen> {
  late SharedPreferences superUser;
  @override
  void initState() {
    super.initState();
    savesuperuserData();
  }

  Future<void> savesuperuserData() async {
    superUser = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262BA5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  superUser.setString("mobile", widget.mobile);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                  child: Image.asset("assets/png/Group 4767.png"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/png/blood-bag.png"),
                      Image.asset("assets/png/hours.png")
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset("assets/png/super user.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 13.0, left: 8.0, right: 8.0, bottom: 17.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      constraints:
                          const BoxConstraints(maxHeight: double.infinity),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 23, 26, 99),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 59.0, right: 17.0, left: 17.0),
                            child: Image.asset("assets/png/Group 4757.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 31.0, right: 17.0, left: 17.0),
                            child: Image.asset("assets/png/Group 4756.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 31.0, right: 17.0, left: 17.0),
                            child: Image.asset("assets/png/Group 4755.png"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 19.0, right: 19.0, bottom: 11.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Authentication.updateSuperUser(
                                    widget.mobile, "yes", context);
                                AllWidgets.toast("Loading Services......");
                                superUser.setString("mobile", widget.mobile);
                                Timer(const Duration(seconds: 5), () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomeScreen()),
                                      (Route route) => false);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50), //
                                  primary: const Color(0xFF2268FF),
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              child: const Text(
                                "BECOME SUPER USER",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
