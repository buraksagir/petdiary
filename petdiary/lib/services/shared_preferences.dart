import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static const String _tokenKey = 'token';
  static const String _userId = 'userId';

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  Future<void> saveToken(String token, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userId, userId);
    log("Token saved\nuserId: $userId\ntoken: $token");
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userId);
    log("userId and tokenKey deleted");
  }
}
