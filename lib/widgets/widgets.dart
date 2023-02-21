import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllWidgets {
  static toast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 15);
  }

  static Widget button(voidCallback, String text) {
    return ElevatedButton(
      onPressed: voidCallback,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50), //
          primary: const Color(0xFF2268FF),
          textStyle: const TextStyle(fontWeight: FontWeight.bold)),
      child: Text(text),
    );
  }
}
