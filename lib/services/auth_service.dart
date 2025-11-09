import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../api/api_helper.dart';
import 'package:flutter/material.dart';

class AuthService {

  //********* LOGIN *********//
  Future<User?> login({required String phone, required String password}) async {
    try {
      final response = await ApiHelper.post('/users/login', {
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data['user']);
        final token = user.token; // token from backend

        // Save token + user locally using SharedPreferences
        await saveToken(token ?? '');
        await saveUser(user);

        debugPrint('✅ Logged in: ${user.name}');
        return user;
      } else {
        debugPrint('❌ Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Login exception: $e');
      return null;
    }
  }

  //********* LOGOUT *********//
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    debugPrint('🚪 User logged out');
  }

  //********* SAVE / LOAD USER *********//
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    if (jsonString == null) return null;
    return User.fromJson(jsonDecode(jsonString));
  }

  //********* SAVE / LOAD TOKEN *********//
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  //********* FORGET PASSWORD *********//
  Future<bool> forgetPassword(String phone, String newPassword) async {
    try {
      final response = await ApiHelper.post('/users/reset-password', {
        'phone': phone,
        'newPassword': newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Forget password exception: $e');
      return false;
    }
  }

  //********* SIGN UP *********//
Future<User?> signup({
  required String name,
  required String lastname,
  required String email,
  required String phone,
  required String password,
 required String? avatar,
 required String? gender,
 required String? birthday,
}) async {
  try {
    final response = await ApiHelper.post('/users/register', {
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'avatar': avatar,
      'gender': gender,
      'birthday': birthday,
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      await saveUser(user);
      debugPrint('✅ Signup successful: ${user.phone}');
      return user;
    }
    return null;
  } catch (e) {
    debugPrint('❌ Signup exception: $e');
    return null;
  }
}

  //********* REQUEST OTP *********//
  Future<bool> requestOtp(String phone) async {
    try {
      final response = await ApiHelper.post('/users/request-otp', {'phone': phone});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Request OTP exception: $e');
      return false;
    }
  }
  //********* REQUEST OTP for signup *********//
  Future<bool> requestOtpSignup(String phone) async {
    try {
      final response = await ApiHelper.post('/users/request-otp-signup', {'phone': phone});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Request OTP exception: $e');
      return false;
    }
  }



  //********* VERIFY OTP *********//
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await ApiHelper.post('/users/verify-otp', {'phone': phone, 'otp': otp});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ Verify OTP exception: $e');
      return false;
    }
  }



  //********* UPDATE PROFILE *********//
Future<User?> updateProfile({
  required String name,
  required String lastname,
  required String email,
  required String phone,
  String? avatar,
  String? gender,
  String? birthday,
}) async {
  try {
    final response = await ApiHelper.put(
      '/users/profile',
      {
        'name': name,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'gender': gender,
        'birthday': birthday,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      await saveUser(user); // save updated user locally
      debugPrint('✅ Profile updated: ${user.name}');
      return user;
    } else {
      debugPrint('❌ Update profile failed: ${response.body}');
      return null;
    }
  } catch (e) {
    debugPrint('❌ Update profile exception: $e');
    return null;
  }
}
}
