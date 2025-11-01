import '../data/test_login_data.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_data.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

class AuthService {
  //********* LOGIN *********//

  Future<LoginData?> login({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final user in testUsers) {
      if (user.phone == phone && user.password == password) {
        // ✅ Simulate token
        final token =
            'token_${user.phone}_${DateTime.now().millisecondsSinceEpoch}';

        // ✅ Create login data
        final loginData = LoginData(
          phone: phone,
          password: password,
          token: token,
        );

        await _saveLoginData(loginData);

        // ✅ Fetch user data (simulate /me)
        final userData = await fetchUser(phone);
        if (userData != null) {
          userData.token = token;
          await saveUserData(userData);
          debugPrint('✅ Logged in user: ${userData.name}');
        }

        return loginData;
      }
    }
    return null;
  }

  //********* FETCH USER *********//
  Future<UserData?> fetchUser(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = testUsers.firstWhere((u) => u.phone == phone);

      return UserData(
        name: user.name,
        lastname: user.lastname,
        phone: user.phone,
        email: user.email,
        avatar: user.avatar,
        gender: user.gender,
        birthday: user.birthday,
        babies: user.babies,
      );
    } catch (e) {
      debugPrint('❌ User not found for phone: $phone');
      return null;
    }
  }

  //********* SAVE / LOAD USER *********//
  Future<void> saveUserData(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  Future<UserData?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString == null) return null;
    return UserData.fromJson(jsonDecode(jsonString));
  }

  //********* SAVE / LOAD LOGIN *********//
  Future<void> _saveLoginData(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_phone', data.phone ?? '');
    await prefs.setString('login_token', data.token ?? '');
  }

  Future<LoginData?> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('login_phone');
    final token = prefs.getString('login_token');
    if (phone != null &&
        phone.isNotEmpty &&
        token != null &&
        token.isNotEmpty) {
      return LoginData(phone: phone, token: token);
    }
    return null;
  }

  //********* LOGOUT *********//
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_phone');
    await prefs.remove('login_token');
    await prefs.remove('user_data');
    debugPrint('🚪 User logged out');
  }

  //********* FORGET PASSWORD *********//
  Future<String?> forgetPassVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (!exists) return null;

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];
    debugPrint('📱 Sending login code $code to $phone');
    return code;
  }

  Future<bool> forgetPassCreatePassword({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final userIndex = testUsers.indexWhere((user) => user.phone == phone);
    if (userIndex == -1) return false;

    testUsers[userIndex] = testUsers[userIndex].copyWith(password: password);
    debugPrint('🔐 Password updated for $phone');
    return true;
  }

  //********* SIGN UP *********//
  Future<String?> signupVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (exists) return null;

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];
    debugPrint('📱 Sending signup code $code to $phone');
    return code;
  }

  Future<bool> createUser({
    required String name,
    required String lastname,
    required String email,
    required String phone,
    required String password,
    String? avatar,
    String? gender,
    String? birthday,
    String? otpCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final exists = testUsers.any((user) => user.phone == phone);
    if (exists) return false;

    final newUser = TestUser(
      name: name,
      lastname: lastname,
      email: email,
      phone: phone,
      password: password,
      avatar: avatar,
      gender: gender,
      birthday: birthday,
      otpCode: otpCode,
    );

    testUsers.add(newUser);
    debugPrint('✅ User created: $phone');
    return true;
  }
}
