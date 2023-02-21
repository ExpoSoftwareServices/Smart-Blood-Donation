import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<SharedPreferences> preference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }
}
