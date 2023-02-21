// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/services/service.dart';
import 'package:smartblood/widgets/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obsecureValue = true;
  bool buttonVisibility = false;
  late String bdEmail;
  late String bdName;
  late String bdMobile;
  late String bdgender;
  late String bdgroup;
  late String bdpassword;
  final globalKey = GlobalKey<FormState>();
  late SingleValueDropDownController _cnt;
  late SingleValueDropDownController _bcnt;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  String? _currentAddress;
  Position? _currentPosition;
  bool checkPermission = false;
  bool checkLocation = false;
  String? mtoken;
  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _bcnt = SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    _bcnt.dispose();
    emailController.dispose();
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  storeNotificationToken()async{
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      mtoken = token;
    });
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await Service.handleLocationPermission(context);
    setState(() {
      checkPermission = hasPermission;
    });

    if (!hasPermission) {
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        checkLocation = true;
        _currentAddress =
            '${place.subLocality} , ${place.subAdministrativeArea} , ${place.postalCode}';
        if (kDebugMode) {
          print(_currentPosition!.latitude);
        }
        if (kDebugMode) {
          print(_currentPosition!.longitude);
        }
        if (kDebugMode) {
          print(_currentAddress);
        }
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          setState(() {
            buttonVisibility = globalKey.currentState!.validate();
          });
        },
        key: globalKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 24.0),
                child: Text(
                  "Create an Account",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28.0,
                      letterSpacing: 0.44),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5.1, left: 24.0),
                child: Text(
                  "Welcome to bloodDonor",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      letterSpacing: 0.44,
                      color: Color(0xFF728192)),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728192))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required Field';
                    } else if (EmailValidator.validate(value) == false) {
                      return 'Invalid Email Address';
                    } else {
                      bdEmail = value;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Name',
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728192))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required Field';
                    } else {
                      bdName = value;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter Mobile Number',
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728192))),
                  validator: (value) {
                    final phoneRegExp = RegExp(r"^[0-9]{10}$");
                    if (value!.isEmpty) {
                      return 'Required Field';
                    } else if (phoneRegExp.hasMatch(value) == false) {
                      return 'Invalid Mobile Number';
                    } else {
                      bdMobile = value;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: DropDownTextField(
                  clearOption: false,
                  textFieldDecoration: const InputDecoration(
                    hintText: 'Gender',
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  controller: _cnt,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    } else {
                      bdgender = value;
                    }
                    return null;
                  },
                  dropDownItemCount: 2,
                  dropDownList: const [
                    DropDownValueModel(name: 'Male', value: "Male"),
                    DropDownValueModel(name: 'Female', value: "Female"),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: DropDownTextField(
                  clearOption: false,
                  textFieldDecoration: const InputDecoration(
                    hintText: 'BloodGroup',
                    labelText: 'BloodGroup',
                    border: OutlineInputBorder(),
                  ),
                  controller: _bcnt,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required Field";
                    } else {
                      bdgroup = value;
                    }
                    return null;
                  },
                  dropDownItemCount: 8,
                  dropDownList: const [
                    DropDownValueModel(name: 'A+', value: "A+"),
                    DropDownValueModel(name: 'A-', value: "A-"),
                    DropDownValueModel(name: 'B+', value: "B+"),
                    DropDownValueModel(name: 'B-', value: "B-"),
                    DropDownValueModel(name: 'AB+', value: "AB+"),
                    DropDownValueModel(name: 'AB-', value: "AB-"),
                    DropDownValueModel(name: 'O+', value: "O+"),
                    DropDownValueModel(name: 'O-', value: "O-"),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: obsecureValue,
                  decoration: InputDecoration(
                      suffixIcon: obsecureValue == true
                          ? IconButton(
                              icon: const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obsecureValue = false;
                                });
                              },
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  obsecureValue = true;
                                });
                              },
                              icon: const Icon(Icons.visibility)),
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      hintStyle: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF728192))),
                  validator: (value) {
                    final passwordRegExp =
                        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$");
                    if (value!.isEmpty) {
                      return 'Required Field';
                    } else if (passwordRegExp.hasMatch(value) == false) {
                      return 'Min 6 chars, at least 1 letter and 1 Number';
                    } else {
                      bdpassword = value;
                    }
                    return null;
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, bottom: 24.0, top: 24.0),
          child: buttonVisibility == false
              ? AllWidgets.button(
                  null,
                  checkPermission == true && checkLocation == true
                      ? "CREATE AN ACCOUNT"
                      : "VERIFY LOCATION")
              : checkPermission == true && checkLocation == false
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const CircularProgressIndicator()
                      ],
                    )
                  : AllWidgets.button(
                      checkPermission == true && checkLocation == true
                          ? () async {
                              setState(() {
                                buttonVisibility = false;
                              });
                              Register register = Register(
                                  email: bdEmail,
                                  name: bdName,
                                  mobile: bdMobile,
                                  gender: bdgender,
                                  bloodgroup: bdgroup,
                                  password: bdpassword,
                                  location: "",
                                  state: "",
                                  lat: _currentPosition!.latitude,
                                  long: _currentPosition!.longitude,
                                  address: _currentAddress,
                                  superuser: "no",
                                  mtoken: mtoken,
                                  isdonated: false,
                                  rewardpoints: 0,
                                  donateddate: Timestamp.now()
                                  );
                              bool docExists =
                                  await Authentication.checkIfDocExists(
                                      bdMobile);
                              bool emailExists =
                                  await Authentication.checkIfEmailExists(
                                      bdEmail);
                              if (docExists == false && emailExists == false) {
                                Authentication.createUser(
                                    register, bdMobile, context);
                                AllWidgets.toast("Account Created !!");
                              } else if (emailExists == true) {
                                AllWidgets.toast("Email Already Taken");
                              } else {
                                AllWidgets.toast(
                                    "Account Exists with $bdMobile");
                              }
                            }
                          : () async {
                              getCurrentPosition();
                              storeNotificationToken();

                            },
                      checkPermission == true && checkLocation == true
                          ? "CREATE AN ACCOUNT"
                          : "VERIFY LOCATION"),
        ),
      ),
    );
  }
}
