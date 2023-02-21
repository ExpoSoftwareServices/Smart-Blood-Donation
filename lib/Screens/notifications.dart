// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartblood/Model/notificationsmodel/notifications.dart';
import 'package:smartblood/firebaseinstances/instance.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen(this.mobile, {super.key});
  String mobile;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List allnotifications = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 238, 239, 255),
        elevation: 0,
        title: Text(
          "Notifications",
          style: GoogleFonts.notoSans(
              fontWeight: FontWeight.w400,
              fontSize: 24.0,
              letterSpacing: 0.44,
              color: Colors.black),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 239, 255),
      body: StreamBuilder<DocumentSnapshot>(
          stream:
              Instances.notificationsInstance.doc(widget.mobile).snapshots(),
          builder: (context, notificationssnapshot) {
            if (notificationssnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (notificationssnapshot.connectionState ==
                    ConnectionState.done ||
                notificationssnapshot.connectionState ==
                    ConnectionState.active) {
              if (notificationssnapshot.hasError) {
                return const Text("Error Occured !! ");
              } else if (notificationssnapshot.hasData &&
                  notificationssnapshot.data!.exists == true) {
                Map<String, dynamic> noti =
                    notificationssnapshot.data!.data() as Map<String, dynamic>;
                allnotifications = noti["notifications"];
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allnotifications.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Notifications notifications = Notifications(
                                name: allnotifications[index]["name"],
                                date: allnotifications[index]["date"],
                                time: allnotifications[index]["time"],
                                param: allnotifications[index]['param']
                                );
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 13.0),
                              child: Material(
                                elevation: 10,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width,
                                  constraints: const BoxConstraints(
                                      maxHeight: double.infinity),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 4.0,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)), //Border.all
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color.fromARGB(
                                            255, 156, 161, 249),
                                        radius: 25,
                                        child: Text(
                                            notifications.name
                                                .toString()[0]
                                                .toUpperCase(),
                                            style: GoogleFonts.roboto(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white)),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, left: 5.0),
                                          child: notifications.param=="Accept"?RichText(
                                              text: TextSpan(
                                                  text: '${notifications.name} accepted your request, ready to donate on ',
                                                  style: GoogleFonts.notoSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:Colors.black),
                                                  children: [
                                                TextSpan(
                                                    text:
                                                        '${notifications.date} ${notifications.time}',
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                          0xFF787EFF))),
                                              ])):notifications.param=="Cancel"?RichText(
                                              text: TextSpan(
                                                  text: '${notifications.name} Denied your request, to donate on ',
                                                  style: GoogleFonts.notoSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:Colors.black),
                                                  children: [
                                                TextSpan(
                                                    text:
                                                        '${notifications.date} ${notifications.time}',
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                          0xFF787EFF))),
                                              ])):RichText(
                                              text: TextSpan(
                                                  text: '${notifications.name}',
                                                  style: GoogleFonts.notoSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFF787EFF)),
                                                  children: [
                                                TextSpan(
                                                    text:
                                                        ' requested you to donate blood on ${notifications.date} ${notifications.time}',
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black)),
                                              ])),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/png/notifications.png",
                      width: 250,
                      height: 250,
                    ),
                    Text(
                      "No Notifications Found",
                      style: GoogleFonts.notoSans(fontSize: 18.0),
                    )
                  ],
                ));
              }
            } else {
              return const Center(child: Text("Error Occured"));
            }
            return Container();
          }),
    ));
  }
}
