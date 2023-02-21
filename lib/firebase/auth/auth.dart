// ignore_for_file: avoid_print, body_might_complete_normally_nullable, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartblood/Model/registermodel/registermodel.dart';
import 'package:smartblood/Screens/superuser.dart';
import 'package:smartblood/firebaseinstances/instance.dart';
import 'package:smartblood/widgets/widgets.dart';

class Authentication {
  static Future createUser(
      Register model, String primaryKey, BuildContext context) async {
    await Instances.userInstance
        .doc(primaryKey)
        .set(model.toJson(), SetOptions(merge: true))
        .then((value) => Navigator.pop(context))
        .catchError((onError) => print(onError));
  }

  static Future<bool> checkIfDocExists(String primaryKey) async {
    try {
      var doc = await Instances.userInstance.doc(primaryKey).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Register> checkuser(String primaryKey) async {
    Register register = Register();
    try {
      var doc = await Instances.userInstance.doc(primaryKey).get();

      if (doc.exists) {
        Map<String, dynamic> obj = doc.data() as Map<String, dynamic>;

        register = Register(
          email: obj["email"],
          password: obj["password"],
          name: obj["name"],
          gender: obj["gender"],
          mobile: obj["mobile"],
          superuser: obj["superuser"],
          mtoken: obj["mtoken"]
        );
      }
    } catch (e) {
      rethrow;
    }
    return register;
  }

  static updatePassword(
      String primaryKey, String password, BuildContext context) async {
    try {
      await Instances.userInstance
          .doc(primaryKey)
          .update({'password': password}).then((value) {
        AllWidgets.toast("Password Updated");
        Navigator.pop(context);
      }).catchError((onError) => print(onError));
    } catch (e) {
      rethrow;
    }
  }

  static updateSuperUser(String primaryKey, String becomeUsersuper, BuildContext context) async {
    try {
      await Instances.userInstance.doc(primaryKey).update({'superuser':becomeUsersuper}).then((value){
        Navigator.push(context, MaterialPageRoute(builder:(context) => const Superuserscreen(),));
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> checkIfEmailExists(String email) async {
    try {
      QuerySnapshot querySnapshot = await Instances.userInstance.get();
      final allData = querySnapshot.docs.map((e) => e.get("email")).toList();
      if (allData.contains(email)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
