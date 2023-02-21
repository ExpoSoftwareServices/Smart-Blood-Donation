// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartblood/Model/notificationsmodel/notifications.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Model/requestmodel/requestmodel.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/widgets/widgets.dart';

class Fetch {
  static updateLocation(String primaryKey, String city, String state,
      BuildContext context) async {
    try {
      await Instances.userInstance
          .doc(primaryKey)
          .update({'location': city, 'state': state}).then((value) {
        Navigator.pop(context);
      }).catchError((onError) => onError);
    } catch (e) {
      rethrow;
    }
  }

  static makeRequest(String primaryKey, Request request, Request receivereq,
      BuildContext context) async {
    try {
      var doc = await Instances.requestInstance.doc(primaryKey).get();
      if (doc.exists) {
        Map<String, dynamic> fireStoredata = doc.data() as Map<String, dynamic>;
        List list = fireStoredata["requests"];
        list.add(request.toJson());
        var data = {"requests": list};
        Fetch.requestsend(primaryKey, data);
      } else {
        var data = {
          "requests": [request.toJson()]
        };
        Fetch.requestsend(primaryKey, data);
      }
    } catch (e) {
      rethrow;
    }
  }

  static receiveRequest(
      Request request, Request receivereq, BuildContext context) async {
    String requestedUser = request.mobile.toString();
    print(requestedUser);
    try {
      var reqdoc = await Instances.receivedInstance.doc(requestedUser).get();
      print(reqdoc.exists);
      if (reqdoc.exists) {
        Map<String, dynamic> fireStoredata =
            reqdoc.data() as Map<String, dynamic>;
        List list = fireStoredata["received"];
        list.add(receivereq.toJson());
        var data = {"received": list};
        Fetch.requestReceive(requestedUser, data);
      } else {
        var data = {
          "received": [receivereq.toJson()]
        };
        print(data);
        Fetch.requestReceive(requestedUser, data);
      }
    } catch (e) {
      rethrow;
    }
  }

  static requestsend(String primaryKey, var data) async {
    await Instances.requestInstance
        .doc(primaryKey)
        .set(data, SetOptions(merge: true))
        .then((value) => value)
        .catchError((onError) => print(onError));
  }

  static requestReceive(String primaryKey, var data) async {
    await Instances.receivedInstance
        .doc(primaryKey)
        .set(data, SetOptions(merge: true))
        .then((value) => value)
        .catchError((onError) => print(onError));
  }

  static Future<List> requestsofNumber(String primaryKey) async {
    var doc = await Instances.requestInstance.doc(primaryKey).get();
    Map<String, dynamic> fireStoredata = doc.data() as Map<String, dynamic>;
    List list = fireStoredata["requests"];
    return list;
  }

  static updateReceivedStatus(String mobile, List request) {
    Instances.receivedInstance
        .doc(mobile)
        .update({"received": request}).then((value) {
      return value;
    });
  }
  static updateSentStatus(String mobile,String widgetmobile) async{
     var data = await Instances.requestInstance.doc(mobile).get();
     Map<String, dynamic> convert = data.data() as  Map<String, dynamic>;
    List Allsent = convert["requests"];
    int fetchsentindex=Allsent.indexWhere((element) => element["mobile"]==widgetmobile);
    Allsent[fetchsentindex]["status"]="accepted";
    return Allsent;
  }
  static updatesent(String mobile,List sent){
    Instances.requestInstance.doc(mobile).update({"requests": sent}).then((value) {
      return value;
  });
  }
  static sendnotification(Notifications notifications,String mobile) async{
    String requestedUser = mobile.toString();
     try {
      var reqdoc = await Instances.notificationsInstance.doc(requestedUser).get();
      print(reqdoc.exists);
      if (reqdoc.exists) {
        Map<String, dynamic> fireStoredata = reqdoc.data() as Map<String, dynamic>;
        List list = fireStoredata["notifications"];
        list.add(notifications.toJson());
        var data = {"notifications": list};
        Fetch.notificationsStore(requestedUser, data);
      } else {
        var data = {
          "notifications": [notifications.toJson()]
        };
        print(data);
        Fetch.notificationsStore(requestedUser, data);
      }
    } catch (e) {
      rethrow;
    }
  }
  static notificationsStore(String primaryKey,var data) async{
    print(data);
    print(primaryKey);
     await Instances.notificationsInstance
        .doc(primaryKey)
        .set(data, SetOptions(merge: true))
        .then((value) => value)
        .catchError((onError) => print(onError));
  }
  static Future<Register> getRewardpoints(String primaryKey) async{
    Register status = Register();
     try {
      var reqdoc = await Instances.userInstance.doc(primaryKey).get();
      if (reqdoc.exists) {
       Map<String, dynamic> obj = reqdoc.data() as Map<String, dynamic>;

         status = Register(
          isdonated: obj["isdonated"],
          rewardpoints: obj['rewardpoints'],
          donateddate: obj['donateddate']

        );

      }
    } catch (e) {
      rethrow;
    }
    return status;
  }
  static updateLocationfirebase(String primaryKey,String currentAddress,var latitude,var longitude,BuildContext context) async{
   await Instances.userInstance.doc(primaryKey).update({"address":currentAddress,"lat":latitude,"long":longitude}).then((value){
   if (kDebugMode) {
     print(currentAddress);
   }
   if (kDebugMode) {
     print(latitude);
   }
  });
  }
}
