// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  late AndroidNotificationChannel channel;

    void initialize() {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("appicon"));
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static void sendNotification(String title ,String token,String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAJydvcRg:APA91bEoWieltXB4rsCzqn0_1GuWDZ6uYzzpz7h40RJWyk0Se9sH-HfokNEk8DnVUtt5lEvjG5nTxk6l_xiKVNZJyo-P3muF8eIoazOUAWWFP3UU-DQbYxIFG6Aq9hPV5WbgPesyNFWg',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen':"ScreenA"

            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
  void display() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'appicon',
              priority: Priority.high,
              color: Color.fromRGBO(255, 255, 255, 0)

            ),
          ),
        );
      }
    });
  }
   void loadFCM() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  static void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  // static final FlutterLocalNotificationsPlugin
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // static void initialize() {
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: AndroidInitializationSettings("@mipmap/ic_launcher"));
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // static void display(RemoteMessage message) async {
  //   try {
  //     if (kDebugMode) {
  //       print("In Notification method");
  //     }
  //     Random random = Random();
  //     int id = random.nextInt(1000);
  //     final NotificationDetails notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //       "mychanel",
  //       "my chanel",
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     ));

  //     if (kDebugMode) {
  //       print("my id is ${id.toString()}");
  //     }
  //     await flutterLocalNotificationsPlugin.show(
  //       id,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //     );
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print('Error>>>$e');
  //     }
  //   }
  // }

  // static sendNotification(String title, String token,String body) async {
  //   final data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     'id': '1',
  //     'status': 'done',
  //     'message': title,
  //     'screen':"ScreenA",
  //   };

  //   try {
  //     http.Response response =
  //         await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //             headers: <String, String>{
  //               'Content-Type': 'application/json',
  //               'Authorization':
  //                   'key=AAAAJydvcRg:APA91bEoWieltXB4rsCzqn0_1GuWDZ6uYzzpz7h40RJWyk0Se9sH-HfokNEk8DnVUtt5lEvjG5nTxk6l_xiKVNZJyo-P3muF8eIoazOUAWWFP3UU-DQbYxIFG6Aq9hPV5WbgPesyNFWg'
  //             },
  //             body: jsonEncode(<String, dynamic>{
  //               'notification': <String, dynamic>{
  //                 'title': title,
  //                 'body': body,
  //               },
  //               'priority': 'high',
  //               'data': data,
  //               'to': token
  //             }));

  //     if (response.statusCode == 200) {
  //       if (kDebugMode) {
  //         print("Yeh notificatin is sended");
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print("Error");
  //       }
  //     }
  //   } catch (e) {
  //     return e;
  //   }
  // }
}
