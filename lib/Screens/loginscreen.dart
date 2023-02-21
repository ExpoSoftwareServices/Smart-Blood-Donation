// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Screens/forgetpass.dart';
import 'package:smartblood/Screens/homescreen.dart';
import 'package:smartblood/Screens/registerscreen.dart';
import 'package:smartblood/Screens/skip.dart';
import 'package:smartblood/firebase/auth/auth.dart';
import 'package:smartblood/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loginVisibility = false;
  bool obsecureValue = true;
  late String loginMobile;
  late String password;
  final globalKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    saveData();
  }

  Future<void> saveData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

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
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          onChanged: () {
            setState(() {
              loginVisibility = globalKey.currentState!.validate();
            });
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 170.0, left: 22.0),
                  child: Text(
                    "Welcome Back!",
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
                    "Please enter your credentials to login",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 0.33,
                        color: Color(0xFF728192)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 22.0, top: 14.0, right: 26.0),
                  child: TextFormField(
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 22.0, top: 14.0, right: 26.0),
                  child: TextFormField(
                    obscureText: obsecureValue,
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: 'Enter Password',
                        labelText: 'Password',
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
                        border: const OutlineInputBorder(),
                        hintStyle: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF728192))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      } else {
                        password = value;
                      }
                      return null;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PasswordScreen()));
                      },
                      child: const Text(
                        "Forget Password ?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            letterSpacing: 0.44,
                            color: Color(0xFF787EFF)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  child: const Text(
                    "Don’t have an account? create one",
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
                child: loginVisibility == false
                    ? AllWidgets.button(null, "LOGIN")
                    : AllWidgets.button(() async {
                        bool docExists =
                            await Authentication.checkIfDocExists(loginMobile);
                        Register docExistsObject =
                            await Authentication.checkuser(loginMobile);
                        if (!docExists) {
                          AllWidgets.toast("Invalid Mobile number");
                        } else {
                          if (password == docExistsObject.password) {
                            String superuser =
                                docExistsObject.superuser.toString();
                            if (superuser == "yes") {
                              sharedPreferences.setString(
                                  "mobile", loginMobile);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SkipScreen(loginMobile),
                                  ));
                            }
                          } else {
                            AllWidgets.toast("Password Incorrect");
                          }
                        }
                      }, "LOGIN")),
          ],
        ),
      ),
    );
  }
}
