import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartblood/Screens/homescreen.dart';
import 'package:smartblood/Screens/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? mobile;
  @override
  void initState() {
    super.initState();
    getData();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  mobile != null ? const HomeScreen() : const LoginScreen()
              )
        );
    });
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getMobile = prefs.getString('mobile');
    setState(() {
      mobile = getMobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          backgroundColor: const Color(0xFF262BA5),
          body: Center(
            child: SvgPicture.asset(
              'assets/svg/splashlogo.svg',
            ),
          )),
    );
  }
}
