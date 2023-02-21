// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smartblood/Screens/homescreen.dart';
import 'package:smartblood/Screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartblood/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:smartblood/services/pushservice.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<void> _handleMessage(RemoteMessage message) async {
    print(message.data);
    if (message.data["screen"] == "ScreenA") {
      navigatorKey.currentState!
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blood Donation',
        navigatorKey: navigatorKey,
        theme: ThemeData(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
