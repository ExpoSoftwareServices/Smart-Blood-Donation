import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Superuserscreen extends StatefulWidget {
  const Superuserscreen({super.key});

  @override
  State<Superuserscreen> createState() => _SuperuserscreenState();
}

class _SuperuserscreenState extends State<Superuserscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262BA5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
              child: Image.asset(
                "assets/png/superstar.png",
                width: 350,
                height: 350,
                fit: BoxFit.fill,
              ),
            ),
            const Text(
              "congrats you are a",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 26,
                  letterSpacing: 0.44,
                  color: Colors.white),
            ),
            const SizedBox(height:15),
            SvgPicture.asset("assets/svg/superuser.svg")
          ],
        ),
      ),
    );
  }
}
