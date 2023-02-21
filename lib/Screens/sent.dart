// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartblood/Model/requestmodel/requestmodel.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/widgets/widgets.dart';

class SentScreen extends StatefulWidget {
  SentScreen(this.mobilenumber, {super.key});
  String mobilenumber;

  @override
  State<SentScreen> createState() => _SentScreenState();
}

class _SentScreenState extends State<SentScreen> {
  List filters = ["all", "pending", "accepted"];
  int selected_filter = 0;
  Request request = Request();
  List filterreq = [];
  List listreq = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream:
                Instances.requestInstance.doc(widget.mobilenumber).snapshots(),
            builder: (context, sendsnapshot) {
              if (sendsnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (sendsnapshot.connectionState == ConnectionState.done ||
                  sendsnapshot.connectionState == ConnectionState.active) {
                if (sendsnapshot.hasError) {
                  return const Text("Error Occured !! ");
                } else if (sendsnapshot.hasData &&
                    sendsnapshot.data!.exists == true) {
                  Map<String, dynamic> yourReq =
                      sendsnapshot.data!.data() as Map<String, dynamic>;
                  filterreq = yourReq["requests"];
                  if (filters[selected_filter] == "all") {
                    listreq = filterreq;
                  } else {
                    listreq = yourReq["requests"];

                    listreq = filterreq
                        .where((element) => element["status"]
                            .toString()
                            .toLowerCase()
                            .contains(filters[selected_filter]
                                .toString()
                                .toLowerCase()))
                        .toList();
                    // print(listreq);

                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 20.0, bottom: 15.0),
                        child: Row(
                          children: [
                            for (int i = 0; i < filters.length; i++)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selected_filter = i;
                                      });
                                    },
                                    child: Container(
                                      height: 26,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          left: 13, right: 13),
                                      decoration: BoxDecoration(
                                          color: selected_filter == i
                                              ? const Color.fromARGB(
                                                  255, 156, 161, 249)
                                              : const Color.fromARGB(
                                                  255, 214, 217, 250),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(filters[i],
                                          style: GoogleFonts.robotoSerif(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                              letterSpacing: 0.4,
                                              color: selected_filter == i
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: listreq.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/png/empty.png"),
                                  Text(
                                    "No ${filters[selected_filter]} requests are Found .",
                                    style: GoogleFonts.notoSans(fontSize: 18.0),
                                  )
                                ],
                              ))
                            : ListView.builder(
                                itemCount: listreq.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  request = Request(
                                      name: listreq[index]['name'],
                                      location: listreq[index]['location'],
                                      bloodgroup: listreq[index]['bloodgroup'],
                                      date: listreq[index]['date'],
                                      status: listreq[index]['status'],
                                      superuser: listreq[index]['superuser']);

                                  return InkWell(
                                    onTap: (){
                                     if(request.status == "Pending"){
                                       AllWidgets.toast("Your Request is Still in Pending ..");
                                     }
                                     else{
                                      AllWidgets.toast("${request.name}accepted Your Request ..");
                                     }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,
                                          left: 18.0,
                                          right: 18.0,
                                          bottom: 5),
                                      child: Material(
                                        elevation: 10,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              constraints: const BoxConstraints(
                                                  maxHeight: double.infinity),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 4.0,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            5)), //Border.all
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            child: Image.asset(
                                                              "assets/png/user.png",
                                                              width: 70,
                                                              height: 70,
                                                              fit: BoxFit.fill,
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                   request.name
                                                                        .toString(),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: GoogleFonts.roboto(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            15.0,
                                                                        color: const Color(
                                                                            0xFF787EFF),
                                                                        letterSpacing:
                                                                            0.44),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  request.superuser ==
                                                                          "no"
                                                                      ? Container()
                                                                      : const Icon(
                                                                          Icons
                                                                              .check_circle_rounded,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              50,
                                                                              39,
                                                                              176),
                                                                          size:
                                                                              15,
                                                                        ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/svg/location_s.svg",
                                                                        width: 10,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Text(
                                                                        request
                                                                            .location
                                                                            .toString(),
                                                                        style: GoogleFonts.roboto(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.44),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        "assets/png/blooddrop.png",
                                                                        width: 12,
                                                                        height:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      Text(
                                                                        request
                                                                            .bloodgroup
                                                                            .toString(),
                                                                        style: GoogleFonts.roboto(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontSize:
                                                                                12.0,
                                                                            letterSpacing:
                                                                                0.44),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  RichText(
                                                                      text: TextSpan(
                                                                          text: 'requested on ',
                                                                          style: GoogleFonts.notoSans(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          children: [
                                                                        TextSpan(
                                                                            text: request
                                                                                .date,
                                                                            style: GoogleFonts.notoSans(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w700,
                                                                                color: const Color(0xFF787EFF))),
                                                                      ])),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                  Expanded(
                                                    child: Container(
                                                      height: 18,
                                                      alignment: Alignment.center,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10, right: 10),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              const Color.fromARGB(
                                                                  255,
                                                                  214,
                                                                  217,
                                                                  250),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15)),
                                                      child: Text(
                                                          request.status.toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts
                                                              .robotoSerif(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 9.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  color: Colors
                                                                      .black)),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      )
                    ],
                  );
                } else {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/png/empty.png"),
                      Text(
                        "No Sent Requests are Found .",
                        style: GoogleFonts.notoSans(fontSize: 18.0),
                      )
                    ],
                  ));
                }
              } else {
                return Container();
              }
            }));
  }
}
