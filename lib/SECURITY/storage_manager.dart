import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class PerfectStateManager {
  static Future<void> saveState(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value); 
    } else if (value is List<String>) {
      prefs.setStringList(key, value); 
    } else {
      log("Invalid data type");
    }
  }

  static Future<bool> checkAuthState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    return isAuthenticated;
  }

  static Future<dynamic> readState(String key) async {
    var prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  static Future<bool> deleteState(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
