// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartblood/Screens/receive.dart';
import 'package:smartblood/Screens/sent.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen(this.mobilenumber,{super.key});
  String mobilenumber;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color.fromARGB(255, 214, 217, 250),
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 214, 217, 250),
          title: Text(
            "Requests",
            style: GoogleFonts.notoSans(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.44,
                color: Colors.black),
          ),
          bottom: TabBar(
            indicatorWeight: 2.0,
            indicatorColor: const Color(0xFF787EFF),
            labelStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 23.0,
              letterSpacing: 0.44,
            ),
            labelColor: Colors.black,
            tabs: const [
              Tab(
                text: 'sent',
              ),
              Tab(
                text: 'recieved',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [SentScreen(widget.mobilenumber), ReceiveScreen(widget.mobilenumber)],
        ),
      ),
    ));
  }
}
