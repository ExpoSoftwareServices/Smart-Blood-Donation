// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartblood/Model/notificationsmodel/notifications.dart';
import 'package:smartblood/Model/requestmodel/requestmodel.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/firebase/backend/backend.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/services/pushservice.dart';
import '../Model/registermodel/registermodel.dart';

class ReceiveScreen extends StatefulWidget {
  ReceiveScreen(this.mobile, {super.key});
  String mobile;

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  List Allreq = [];
  List Allsent = [];
  Request request = Request();
  Register register = Register();
  @override
  void initState() {
    super.initState();
    profileDetails();
  }

  profileDetails() async {
    Register reg = await Authentication.checkuser(widget.mobile);
    setState(() {
      register = reg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: Instances.receivedInstance.doc(widget.mobile).snapshots(),
          builder: (context, receivesnapshot) {
            if (receivesnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (receivesnapshot.connectionState ==
                    ConnectionState.done ||
                receivesnapshot.connectionState == ConnectionState.active) {
              if (receivesnapshot.hasError) {
                return const Text("Error Occured !! ");
              } else if (receivesnapshot.hasData &&
                  receivesnapshot.data!.exists == true) {
                Map<String, dynamic> donarReq =
                    receivesnapshot.data!.data() as Map<String, dynamic>;
                Allreq = donarReq["received"];
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: Allreq.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            request = Request(
                                name: Allreq[index]['name'].toString(),
                                location: Allreq[index]['location'].toString(),
                                bloodgroup:
                                    Allreq[index]['bloodgroup'].toString(),
                                date: Allreq[index]['date'].toString(),
                                time: Allreq[index]['time'].toString(),
                                dist: Allreq[index]['dist'],
                                accomodation: Allreq[index]['accomodation'],
                                charges: Allreq[index]['charges'],
                                superuser: Allreq[index]['superuser'],
                                status: Allreq[index]['status'],
                                mtoken: Allreq[index]['mtoken'],
                                isdonated: Allreq[index]['isdonated'],
                                receivedfrom: Allreq[index]['receivedfrom']);
                            Request name = Request(
                              name: Allreq[index]["name"],
                              mobile: Allreq[index]["mobile"],
                            );
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 17.0,
                                  bottom: 6.0),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.asset(
                                              "assets/png/user.png",
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      request.name.toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 15.0,
                                                          color: const Color(
                                                              0xFF787EFF),
                                                          letterSpacing: 0.44),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    request.superuser == "no"
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    50,
                                                                    39,
                                                                    176),
                                                            size: 20,
                                                          ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              219, 221, 254),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/svg/location_s.svg",
                                                            width: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0,
                                                                    right: 5),
                                                            child: Text(
                                                              request.location
                                                                  .toString(),
                                                              style: GoogleFonts.roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.44),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              219, 221, 254),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/png/blooddrop.png",
                                                            width: 12,
                                                            height: 12,
                                                            color: Colors.black,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0,
                                                                    right: 5),
                                                            child: Text(
                                                              request.bloodgroup
                                                                  .toString(),
                                                              style: GoogleFonts.roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.44),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Allreq[index]['isdonated'] == true
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${request.name} received Blood from ${request.receivedfrom == register.name ? "You" : request.receivedfrom} on ${request.date} ${request.time}",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("By ",
                                                          style: GoogleFonts
                                                              .notoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                          )),
                                                      Text(
                                                          "${request.date}   ${request.time}",
                                                          style: GoogleFonts
                                                              .notoSans(
                                                            color: const Color(
                                                                0xFF787EFF),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 15,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color: Color.fromARGB(
                                                          255, 50, 39, 176),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  'User is in range of ',
                                                              style: GoogleFonts
                                                                  .notoSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: [
                                                            TextSpan(
                                                                text:
                                                                    '${request.dist} KMS ',
                                                                style: GoogleFonts
                                                                    .notoSans(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                )),
                                                            TextSpan(
                                                              text:
                                                                  'from your location',
                                                              style: GoogleFonts
                                                                  .notoSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            )
                                                          ])),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                request.accomodation == false
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    50,
                                                                    39,
                                                                    176),
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Provides accomodation",
                                                            style: GoogleFonts
                                                                .notoSans(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                request.charges == false
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    50,
                                                                    39,
                                                                    176),
                                                            size: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Provides travel cost",
                                                            style: GoogleFonts
                                                                .notoSans(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                request.status == "accepted"
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color: Colors
                                                                    .green,
                                                                size: 20,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "You Accepted Request Successfully",
                                                                style: GoogleFonts
                                                                    .notoSans(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Notifications
                                                                  notifications =
                                                                  Notifications(
                                                                      name: register
                                                                          .name,
                                                                      date: request
                                                                          .date,
                                                                      time: request
                                                                          .time,
                                                                      param:
                                                                          "Cancel");
                                                              Allreq[index][
                                                                      "status"] =
                                                                  "Pending";
                                                              Fetch.updateReceivedStatus(
                                                                  widget.mobile,
                                                                  Allreq);
                                                              List Allsent = await Fetch
                                                                  .updateSentStatus(
                                                                      name.mobile
                                                                          .toString(),
                                                                      widget
                                                                          .mobile);
                                                              int fetchsentindex =
                                                                  Allsent.indexWhere((element) =>
                                                                      element[
                                                                          "mobile"] ==
                                                                      widget
                                                                          .mobile);

                                                              Allsent[fetchsentindex]
                                                                      [
                                                                      "status"] =
                                                                  "Pending";
                                                              Fetch.updatesent(
                                                                  name.mobile
                                                                      .toString(),
                                                                  Allsent);
                                                              Fetch.sendnotification(
                                                                  notifications,
                                                                  name.mobile
                                                                      .toString());
                                                              LocalNotificationService.sendNotification(
                                                                  "${notifications.name} Denied Your Request",
                                                                  Allreq[index][
                                                                      "mtoken"],
                                                                  "to donate Blood on ${notifications.date} ${notifications.time}");
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              fixedSize:
                                                                  const Size(
                                                                      330, 0),
                                                              primary:
                                                                  Colors.black,
                                                              side: const BorderSide(
                                                                  width: 1,
                                                                  color: Color(
                                                                      0xFF787EFF)),
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      214,
                                                                      217,
                                                                      250), // Background Color
                                                            ),
                                                            child: Text(
                                                              'CANCEL',
                                                              style: GoogleFonts.roboto(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4.0,
                                                                right: 4.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Notifications notifications = Notifications(
                                                                      name: register
                                                                          .name,
                                                                      date: request
                                                                          .date,
                                                                      time: request
                                                                          .time,
                                                                      param:
                                                                          "Accept");
                                                                  showalert(
                                                                      context,
                                                                      name.name
                                                                          .toString(),
                                                                      "Accept",
                                                                      Allreq,
                                                                      index,
                                                                      Allsent,
                                                                      name.mobile
                                                                          .toString(),
                                                                      notifications);
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  primary: Colors
                                                                      .white,
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFF787EFF), // Background Color
                                                                ),
                                                                child: Text(
                                                                  'ACCEPT',
                                                                  style: GoogleFonts.roboto(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            ),
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
                    Image.asset("assets/png/empty.png"),
                    Text(
                      "No Received requests are Found .",
                      style: GoogleFonts.notoSans(fontSize: 18.0),
                    )
                  ],
                ));
              }
            } else {
              return const Text("Error Occured !!");
            }
          }),
    );
  }

  showalert(
      BuildContext context,
      String name,
      String word,
      List request,
      int index,
      List Allsent,
      String mobile,
      Notifications notifications) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Request Confirm"),
        content: Text("Do you want to $word $name's Request ?"),
        actions: <Widget>[
          TextButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF787EFF), // Backgr
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.pop(context);
                request[index]["status"] = "accepted";
                List Allsent =
                    await Fetch.updateSentStatus(mobile, widget.mobile);
                int fetchsentindex = Allsent.indexWhere(
                    (element) => element["mobile"] == widget.mobile);
                Allsent[fetchsentindex]["status"] = "accepted";
                Fetch.updatesent(mobile, Allsent);
                Fetch.updateReceivedStatus(widget.mobile, request);
                Fetch.sendnotification(notifications, mobile);
                LocalNotificationService.sendNotification(
                    "${notifications.name} Accepted Your Request",
                    request[index]["mtoken"],
                    "to donate Blood on ${notifications.date} ${notifications.time}");
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF787EFF), // Backgr
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
