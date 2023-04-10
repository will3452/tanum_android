import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as api;
import 'package:tanum/utils/constant.dart';

class Helpers {
  static bool required(value) {
    if (value == null || value.isEmpty) {
      return false;
    }

    return true;
  }

  static Widget loader(isLoading) =>
      isLoading ? LinearProgressIndicator(minHeight: 2.0) : SizedBox(height: 2);

  static void alert({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<bool> setAuth(body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("bearerToken", body['token']);
    await prefs.setString("name", body['user']['name']);
    await prefs.setString('email', body['user']['email']);

    return true;
  }

  static Future<String?> getAuth({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString(key);

    return value;
  }

  static dynamic getUrl(path) {
    if (APP_DEBUG) {
      return Uri.http(API_BASE_URL, path);
    } else {
      return Uri.https(API_BASE_URL, path);
    }
  }

  static Future<bool> logout() async {
    String? token = await Helpers.getAuth(key: 'bearerToken');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    var url = Helpers.getUrl('/api/logout');

    var response = await api.post(url, headers: {
      "Authorization": "Bearer ${token}",
    });

    return true;
  }
}
