// ignore_for_file: must_be_immutable, unused_field, must_call_super, use_build_context_synchronously, non_constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haversine_distance/haversine_distance.dart' as distance;
import 'package:intl/intl.dart';

import 'package:smartblood/Model/mapmodel/mapmodel.dart';
import 'package:smartblood/Model/notificationsmodel/notifications.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Model/requestmodel/requestmodel.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/firebase/backend/backend.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/services/pushservice.dart';
import 'package:smartblood/widgets/widgets.dart';

class UserDetails extends StatefulWidget {
  UserDetails(this.details, this.PersonalData, this.cities, this.mobile,
      {super.key});
  Register details, PersonalData;
  List<Mapdata> cities;
  String? mobile;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<Mapdata> get_poly = [];
  int dist = 0;
  bool checkbox = false;
  bool accomodation = false;
  String formattedTime = "";
  String formattedDate = "";
  List<Request> allRequests = [];
  Register register = Register();
  @override
  void initState() {
    setState(() {
      get_poly = widget.cities
          .where((element) => element.city == widget.details.location)
          .toList();
    });
    final startCoordinate = distance.Location(
        double.parse(get_poly[0].lat.toString()),
        double.parse(get_poly[0].lng.toString()));
    final endCoordinate = distance.Location(
        double.parse(widget.details.lat.toString()),
        double.parse(widget.details.long.toString()));
    final haversineDistance = distance.HaversineDistance();
    dist = haversineDistance
        .haversine(startCoordinate, endCoordinate, distance.Unit.KM)
        .floor();
    profileDetails();
  }

  profileDetails() async {
    Register reg = await Authentication.checkuser(widget.mobile.toString());
    setState(() {
      register = reg;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color.fromARGB(255, 156, 161, 249).withOpacity(0.3),
        statusBarIconBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(maxHeight: double.infinity),
              decoration: const BoxDecoration(color: Color(0xFF787EFF)),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 21.0, top: 31.0, bottom: 21.0),
                child: Row(
                  children: [
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            "assets/png/user.png",
                            width: 140,
                            height: 140,
                            fit: BoxFit.fill,
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Text(
                              widget.details.name.toString(),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Blood group",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Text(
                              widget.details.bloodgroup.toString(),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24.0,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Gender",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400, fontSize: 16.0),
                            ),
                            Text(
                              widget.details.gender.toString(),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 21.0, right: 18.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 211, 213, 255),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0, left: 9.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "address",
                            style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              letterSpacing: 0.44,
                              color: const Color(0xFF6D6D6D),
                            ),
                          ),
                          Text(
                            '${widget.details.location},${widget.details.state}',
                            style: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                letterSpacing: 0.44),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 8.0, right: 18.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 211, 213, 255),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 12.0, bottom: 8.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color.fromARGB(255, 50, 39, 176),
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        text: 'User is in range of ',
                                        style: GoogleFonts.notoSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text: '$dist KMS ',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      TextSpan(
                                        text: 'from your location',
                                        style: GoogleFonts.notoSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ])),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color.fromARGB(255, 50, 39, 176),
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Provides accomodation",
                                style: GoogleFonts.notoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream:
                      Instances.requestInstance.doc(widget.mobile).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 5.0,
                          ),
                          CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.exists) {
                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        List checkreq = data["requests"];
                        for (var element in checkreq) {
                          Request request = Request(
                              accomodation: element['accomodation'],
                              charges: element['charges'],
                              date: element['date'],
                              time: element['time'],
                              status: element['status'],
                              name: element['name'],
                              mobile: element['mobile']);

                          allRequests.add(request);
                        }
                      }
                      List res = allRequests
                          .where((element) => element.name!
                              .toLowerCase()
                              .contains(widget.details.name!.toLowerCase()))
                          .toList();
                      var map = res.asMap();
                      return map[0] != null
                          ? getdetails(map[0], widget.details.gender)
                          : getdetails(map[0], widget.details.gender);
                    }
                    return Container();
                  },
                ), //cool
              ],
            )
          ],
        ),
      ),
    ));
  }

  getdetails(search, gender) {
    return Column(
      children: [
        (search != null ? (gender == "Male" && search.charges == false) : false)
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 8.0, right: 18.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 213, 255),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                    ),
                    child: widget.details.gender == "Female"
                        ? Row(
                            children: [
                              search == null
                                  ? Checkbox(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      value: checkbox,
                                      onChanged: (v) {
                                        setState(() {
                                          checkbox = v!;
                                        });
                                        print(checkbox);
                                      },
                                    )
                                  : Checkbox(
                                      activeColor: const Color.fromARGB(
                                          255, 80, 44, 238),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      value: search.charges,
                                      onChanged: (v) {},
                                    ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  "since the user is a female, you need to provide the security and travel do you agree with this .",
                                  style: GoogleFonts.notoSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                            ],
                          )
                        : search == null
                            ? Row(
                                children: [
                                  Checkbox(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    value: checkbox,
                                    onChanged: (v) {
                                      setState(() {
                                        checkbox = v!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "provide travel charges for user",
                                      style: GoogleFonts.notoSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ))
                                ],
                              )
                            : Row(
                                children: [
                                  search.charges == false && search == null
                                      ? Checkbox(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          value: checkbox,
                                          onChanged: (v) {
                                            setState(() {
                                              checkbox = v!;
                                            });
                                          },
                                        )
                                      : search.charges == false &&
                                              search != null
                                          ? Container()
                                          : Checkbox(
                                              activeColor: const Color.fromARGB(
                                                  255, 80, 44, 238),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0))),
                                              value: search.charges,
                                              onChanged: (v) {},
                                            ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: search.charges == false &&
                                            search != null
                                        ? Container()
                                        : Text(
                                            search.charges != false &&
                                                    search != null
                                                ? "provide travel charges for user"
                                                : "provide travel charges for user",
                                            style: GoogleFonts.notoSans(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400),
                                          ),
                                  ))
                                ],
                              ),
                  ),
                ),
              ),
        (search != null
                ? (gender == "Male" && search.accomodation == false)
                : false)
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 8.0, right: 18.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 213, 255),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                    ),
                    child: search == null
                        ? Row(
                            children: [
                              Checkbox(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                value: accomodation,
                                onChanged: (v) {
                                  setState(() {
                                    accomodation = v!;
                                  });
                                  print(accomodation);
                                },
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Text(
                                  "accomodation for the user",
                                  style: GoogleFonts.notoSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                            ],
                          )
                        : Row(
                            children: [
                              search.accomodation == false && search == null
                                  ? Checkbox(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      value: accomodation,
                                      onChanged: (v) {
                                        setState(() {
                                          accomodation = v!;
                                        });
                                      },
                                    )
                                  : search.accomodation == false &&
                                          search != null
                                      ? Container()
                                      : Checkbox(
                                          activeColor: const Color.fromARGB(
                                              255, 80, 44, 238),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          value: search.accomodation,
                                          onChanged: (value) {},
                                        ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: search.accomodation == false &&
                                        search != null
                                    ? Container()
                                    : Text(
                                        search.accomodation != false &&
                                                search != null
                                            ? "accomodation for the user"
                                            : "accomodation for the user",
                                        style: GoogleFonts.notoSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                              ))
                            ],
                          ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 8.0, right: 18.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxHeight: double.infinity),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 211, 213, 255),
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 2.0, left: 18.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "when do you need blood ?",
                      style: GoogleFonts.roboto(
                          fontSize: 13.0, fontWeight: FontWeight.w400),
                    ),
                    search == null
                        ? InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2023, 12, 31, 23, 59),
                                builder: (context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF787EFF),
                                        onPrimary: Colors.white,
                                      )),
                                      child: child!);
                                },
                              ).then((pickedDate) {
                                setState(() {
                                  formattedDate = DateFormat("dd MMM yyyy")
                                      .format(pickedDate!);
                                });
                                print(formattedDate);
                              });
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'select date   ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: formattedDate.isEmpty
                                          ? 'click here'
                                          : formattedDate,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF787EFF),
                                      )),
                                ])),
                          )
                        : InkWell(
                            onTap: () {
                              search.date!.isNotEmpty
                                  ? Container()
                                  : showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2022, 12, 31, 23, 59),
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                              primary: Color(0xFF787EFF),
                                              onPrimary: Colors.white,
                                            )),
                                            child: child!);
                                      },
                                    ).then((pickedDate) {
                                      setState(() {
                                        formattedDate =
                                            DateFormat("dd MMM yyyy")
                                                .format(pickedDate!);
                                      });
                                      print(formattedDate);
                                    });
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'select date   ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: formattedDate.isEmpty
                                          ? search.date!.isEmpty
                                              ? 'click here'
                                              : search.date!
                                          : formattedDate,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF787EFF),
                                      )),
                                ])),
                          ),
                    search == null
                        ? InkWell(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  helpText: 'TIMER',
                                  builder: (context, child) {
                                    return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              onSurface: Color(0xFF787EFF),
                                            ),
                                            timePickerTheme: TimePickerThemeData(
                                                backgroundColor: Colors.white,
                                                dialHandColor:
                                                    const Color(0xFF787EFF),
                                                entryModeIconColor:
                                                    const Color(0xFF787EFF),
                                                hourMinuteColor: MaterialStateColor.resolveWith((states) => states.contains(
                                                        MaterialState.selected)
                                                    ? const Color(0xFF787EFF)
                                                    : const Color.fromARGB(
                                                        255, 211, 214, 255)),
                                                hourMinuteTextColor:
                                                    Colors.white,
                                                dialBackgroundColor:
                                                    const Color.fromARGB(
                                                        255, 233, 228, 228),
                                                dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                                                    states.contains(MaterialState.selected)
                                                        ? const Color(0xFF787EFF)
                                                        : const Color.fromARGB(255, 216, 218, 245)),
                                                dayPeriodTextColor: Colors.white),
                                            textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => const Color(0xFF787EFF)), textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(fontSize: 15))))),
                                        child: child!);
                                  });
                              if (pickedTime != null) {
                                DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString());
                                setState(() {
                                  formattedTime =
                                      DateFormat("hh:mm a").format(parsedTime);
                                });
                              } else {}
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'select time   ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: formattedTime.isEmpty
                                          ? 'click here'
                                          : formattedTime,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF787EFF),
                                      )),
                                ])),
                          )
                        : InkWell(
                            onTap: search.time!.isNotEmpty
                                ? null
                                : () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                            helpText: 'TIMER',
                                            builder: (context, child) {
                                              return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                          colorScheme:
                                                              const ColorScheme
                                                                  .light(
                                                            onSurface: Color(
                                                                0xFF787EFF),
                                                          ),
                                                          timePickerTheme: TimePickerThemeData(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              dialHandColor: const Color(
                                                                  0xFF787EFF),
                                                              entryModeIconColor:
                                                                  const Color(
                                                                      0xFF787EFF),
                                                              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                                                                  states.contains(MaterialState.selected)
                                                                      ? const Color(
                                                                          0xFF787EFF)
                                                                      : const Color.fromARGB(
                                                                          255,
                                                                          211,
                                                                          214,
                                                                          255)),
                                                              hourMinuteTextColor:
                                                                  Colors.white,
                                                              dialBackgroundColor:
                                                                  const Color.fromARGB(255, 233, 228, 228),
                                                              dayPeriodColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? const Color(0xFF787EFF) : const Color.fromARGB(255, 216, 218, 245)),
                                                              dayPeriodTextColor: Colors.white),
                                                          textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => const Color(0xFF787EFF)), textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(fontSize: 15))))),
                                                  child: child!);
                                            });
                                    if (pickedTime != null) {
                                      DateTime parsedTime = DateFormat.jm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      setState(() {
                                        formattedTime = DateFormat("hh:mm a")
                                            .format(parsedTime);
                                      });
                                      print(formattedTime);
                                    } else {}
                                  },
                            child: RichText(
                                text: TextSpan(
                                    text: 'select time   ',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    children: [
                                  TextSpan(
                                      text: formattedTime.isEmpty
                                          ? search.time!.isNotEmpty
                                              ? search.time!
                                              : 'click here'
                                          : formattedTime,
                                      style: GoogleFonts.notoSans(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF787EFF),
                                      )),
                                ])),
                          ),
                  ],
                )),
          ),
        ),
        search == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 8.0, right: 18.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 211, 213, 255),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, left: 18.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "status",
                          style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            letterSpacing: 0.44,
                            color: const Color(0xFF6D6D6D),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          search.status.toString().toUpperCase(),
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.0,
                              letterSpacing: 0.44,
                              color: const Color(0xFF787EFF)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        search == null
            ? Container()
            : search.status == "accepted"
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 8.0, right: 18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 211, 213, 255),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 18.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mobile",
                              style: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.44,
                                color: const Color(0xFF6D6D6D),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${search.mobile}',
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  letterSpacing: 0.44,
                                  color: const Color(0xFF000000)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
        search == null
            ? Container()
            : search.status == "accepted"
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 8.0, right: 18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      constraints:
                          const BoxConstraints(maxHeight: double.infinity),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 211, 213, 255),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0, left: 18.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "did user donated blood",
                              style: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                letterSpacing: 0.44,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                widget.details.isdonated == false
                                    ? Expanded(
                                        child: TextButton(
                                          onPressed: () async {

                                            var check = await Instances
                                                .receivedInstance
                                                .get();
                                            for (var element in check.docs) {
                                              if (element.id !=
                                                  widget.PersonalData.mobile) {

                                                Map<String, dynamic> k =
                                                    element.data()
                                                        as Map<String, dynamic>;
                                                List divide = k["received"];
                                                int fetchsentindex = divide
                                                    .indexWhere((element) =>
                                                        element["mobile"] ==
                                                        widget.PersonalData.mobile);
                                                if (fetchsentindex >= 0) {
                                                  divide[fetchsentindex]
                                                      ['isdonated'] = true;
                                                  divide[fetchsentindex]['receivedfrom']=widget.details.name.toString();
                                                  print(divide);
                                                  Fetch.updateReceivedStatus(
                                                      element.id, divide);
                                                }
                                              }
                                            }

                                            AllWidgets.toast(
                                                "Thanks for Confirmation ${widget.PersonalData.name}");
                                            var conv = DateFormat("dd MMM yyyy")
                                                .parse(search.date);
                                            Register getStatus =
                                                await Fetch.getRewardpoints(
                                                    widget.details.mobile
                                                        .toString());
                                            getStatus.rewardpoints = int.parse(
                                                    getStatus.rewardpoints
                                                        .toString()) +
                                                50;
                                            bool change_status = true;
                                            Instances.userInstance
                                                .doc(widget.details.mobile)
                                                .update({
                                              "rewardpoints": getStatus.rewardpoints,
                                              "isdonated": change_status,
                                              "donateddate":conv
                                            }).then((value){
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF262BA5)),
                                              backgroundColor:
                                                  const Color(0xFF262BA5)),
                                          child: Text(
                                            'YES',
                                            style: GoogleFonts.roboto(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: TextButton(
                                          onPressed: () async {
                                            Register getStatus =
                                                await Fetch.getRewardpoints(
                                                    widget.details.mobile
                                                        .toString());
                                            getStatus.rewardpoints = int.parse(
                                                    getStatus.rewardpoints
                                                        .toString()) -
                                                50;
                                            bool change_status = false;
                                            Instances.userInstance
                                                .doc(widget.details.mobile)
                                                .update({
                                              "rewardpoints":
                                                  getStatus.rewardpoints,
                                              "isdonated": change_status
                                            }).then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF787EFF)),
                                              backgroundColor:
                                                  const Color(0xFF787EFF)),
                                          child: Text(
                                            'Revert Back ',
                                            style: GoogleFonts.roboto(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
        Padding(
          padding: const EdgeInsets.only(
              left: 13.0, right: 13.0, top: 15.0, bottom: 6.0),
          child: ((checkbox == false || accomodation == false) &&
                          (gender == "Female") ||
                      formattedDate.isEmpty ||
                      formattedTime.isEmpty) &&
                  (search == null)
              ? AllWidgets.button(null, "MAKE A REQUEST")
              : search != null
                  ? Container()
                  : AllWidgets.button(() {
                      Request sendrequest = Request(
                          name: widget.details.name,
                          mobile: widget.details.mobile,
                          bloodgroup: widget.details.bloodgroup,
                          location: widget.details.location,
                          superuser: widget.details.superuser,
                          charges: checkbox,
                          accomodation: accomodation,
                          date: formattedDate,
                          time: formattedTime,
                          status: "Pending");
                      Request receiverequest = Request(
                          name: widget.PersonalData.name,
                          location: widget.PersonalData.location,
                          bloodgroup: widget.PersonalData.bloodgroup,
                          superuser: widget.PersonalData.superuser,
                          mobile: widget.PersonalData.mobile,
                          date: formattedDate,
                          time: formattedTime,
                          charges: checkbox,
                          accomodation: accomodation,
                          dist: dist,
                          status: "Pending",
                          mtoken: widget.PersonalData.mtoken,
                          isdonated: false,
                          receivedfrom: ""
                          );
                      Notifications notification = Notifications(
                          name: register.name,
                          date: sendrequest.date,
                          time: sendrequest.time,
                          param: "Sent");

                      Fetch.makeRequest(widget.mobile.toString(), sendrequest,
                          receiverequest, context);
                      Fetch.receiveRequest(
                          sendrequest, receiverequest, context);
                      Fetch.sendnotification(
                          notification, sendrequest.mobile.toString());
                      print(widget.PersonalData.mtoken);
                      LocalNotificationService.sendNotification(
                          "${widget.PersonalData.name} Sent You a Request",
                          widget.details.mtoken.toString(),
                          "Requested to donate Blood on ${sendrequest.date} ${sendrequest.time}");
                    }, "MAKE A REQUEST"),
        ),
      ],
    );
  }
}
