// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:smartblood/Screens/loginscreen.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/widgets/widgets.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool changeVisibility = false;
  bool obsecureValue = true;
  bool openPasswordbox = false;
  bool passvisibility = false;
  late String loginMobile;
  late String password;
  final globalKey = GlobalKey<FormState>();
  final globalpassKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 170.0, left: 22.0),
              child: Text(
                "Forget Password !",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    letterSpacing: 0.33),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 22.0),
              child: Text(
                "Please enter your Mobile to change passcode",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.33,
                    color: Color(0xFF728192)),
              ),
            ),
            Form(
              key: globalKey,
              onChanged: () {
                setState(() {
                  changeVisibility = globalKey.currentState!.validate();
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 22.0, top: 14.0, right: 26.0),
                child: TextFormField(
                  onChanged: (value) async {
                    bool check = await Authentication.checkIfDocExists(value);
                    if (check == true && value.length == 10) {
                      setState(() {
                        openPasswordbox = true;
                      });
                    } else {
                      setState(() {
                        openPasswordbox = false;
                        passwordController.text="";
                      });
                    }
                  },
                  keyboardType: TextInputType.phone,
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
                      loginMobile = value;
                    }
                    return null;
                  },
                ),
              ),
            ),
            openPasswordbox == false
                ? Container()
                : Form(
                    key: globalpassKey,
                    onChanged: () {
                      setState(() {
                        passvisibility = globalpassKey.currentState!.validate();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 14.0),
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
                            password = value;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 115,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 43.0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Do you have an account? Login",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.44,
                        color: Color(0xFF787EFF)),
                  )),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: changeVisibility == false || passvisibility == false
                    ? AllWidgets.button(null, "CHANGE")
                    : AllWidgets.button(() async {
                        bool docExists =
                            await Authentication.checkIfDocExists(loginMobile);
                        if (!docExists) {
                          AllWidgets.toast("Invalid Mobile number");
                        } else {
                          Authentication.updatePassword(
                              loginMobile, password, context);
                        }
              }, "CHANGE")
            ),
          ],
        ),
      ),
    );
  }
}
