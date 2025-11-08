import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter/foundation.dart';

class ApiHelper {
  static const String baseUrl =
      "http://192.168.1.17:5000"; // change for your backend

  /// Read token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    //debugPrint('🔑 Retrieved token: $token');
    return token;
  }

  /// Build headers with optional authorization
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return headers;
  }

  /// GET request
  static Future<http.Response> get(String path) async {
    final url = '$baseUrl$path';
    final headers = await getHeaders();

    //debugPrint('🔗 GET $url');
    //debugPrint('🔐 Headers: $headers');

    final response = await http.get(Uri.parse(url), headers: headers);
   // debugPrint('📥 Response (${response.statusCode}): ${response.body}');
    return response;
  }

  /// POST request
  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final url = '$baseUrl$path';
    final headers = await getHeaders();
 //   debugPrint('🔗 POST $url');
  //  debugPrint('📦 Body: $body');
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
   // debugPrint('📥 Response (${response.statusCode}): ${response.body}');
    return response;
  }

  /// PUT request
  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final url = '$baseUrl$path';
    final headers = await getHeaders();
  //  debugPrint('🔗 PUT $url');
//debugPrint('📦 Body: $body');
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
   // debugPrint('📥 Response (${response.statusCode}): ${response.body}');
    return response;
  }

  /// DELETE request
  static Future<http.Response> delete(String path) async {
    final url = '$baseUrl$path';
    final headers = await getHeaders();
  //  debugPrint('🔗 DELETE $url');
    final response = await http.delete(Uri.parse(url), headers: headers);
 //   debugPrint('📥 Response (${response.statusCode}): ${response.body}');
    return response;
  }

  /// Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
 //   debugPrint('💾 Token saved');
  }

  /// Remove token (logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
 //   debugPrint('🗑️ Token removed');
  }
}
