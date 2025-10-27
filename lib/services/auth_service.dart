import '../data/test_login_data.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_data.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

UserData? currentUser;

class AuthService {
  //********* LOGIN *********//

  /// Simulated login
  Future<LoginData?> login({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final user in testUsers) {
      if (user.phone == phone && user.password == password) {
        // ✅ Simulate a token
        final token =
            'token_${user.phone}_${DateTime.now().millisecondsSinceEpoch}';

        // ✅ Create login data
        final loginData = LoginData(
          phone: phone,
          password: password,
          token: token,
        );
        await _saveLoginData(loginData);

        // ✅ Fetch user data (simulating /me API)
        final userData = await fetchUser(phone);
        if (userData != null) {
          userData.token = token;
          currentUser = userData;

          // ✅ Save to SharedPreferences
          await saveUserData(userData);

          debugPrint('Logged in user: $userData');
        }

        return loginData;
      }
    }
    return null;
  }

  /// Simulate a `/user` API fetch
  Future<UserData?> fetchUser(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate delay

    final user = testUsers.firstWhere(
      (u) => u.phone == phone,
      orElse: () => throw Exception('User not found'),
    );

    final userData = UserData(
      name: user.name,
      lastname: user.lastname,
      phone: user.phone,
      email: user.email,
      avatar: user.avatar,
      gender: user.gender,
      birthday: user.birthday,
      babies: user.babies,
    );

    return userData;
  }

  //////////// save user data
  Future<void> saveUserData(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString('user_data', jsonString);
  }

  Future<UserData?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString == null) return null;
    return UserData.fromJson(jsonDecode(jsonString));
  }

  ////////// save login data

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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_phone');
    await prefs.remove('login_token');
    currentUser = null;
    await prefs.remove('user_data');
    debugPrint('User logged out');
  }

  //********** FORGET PASSWORD *****/

  /// Simulates verifying if a phone number exists in test data (for login)
  Future<String?> forgetPassVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (!exists) return null;

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];

    debugPrint('📱 [Test] Sending login code $code to $phone');
    return code;
  }

  /// ✅ Simulates creating a new password after OTP verification
  Future<bool> forgetPassCreatePassword({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // Try to find user in test data
    final userIndex = testUsers.indexWhere((user) => user.phone == phone);

    if (userIndex == -1) {
      debugPrint('❌ [Test] User not found for password creation: $phone');
      return false;
    }

    // Update password in simulated data
    testUsers[userIndex] = testUsers[userIndex].copyWith(password: password);

    debugPrint('🔐 [Test] Password successfully created for $phone');
    return true;
  }

  //************* SIGN UP **********/

  /// Simulates verifying if a phone number can be used to sign up
  Future<String?> signupVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (exists) {
      debugPrint('🚫 [Test] Phone already registered: $phone');
      return null;
    }

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];
    debugPrint('📱 [Test] Sending signup code $code to $phone');
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

    // Check if phone already exists
    final exists = testUsers.any((user) => user.phone == phone);
    if (exists) {
      debugPrint('❌ [Test] Cannot create user, phone already exists: $phone');
      return false;
    }

    // Add new user to test data
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

    debugPrint('✅ [Test] User created: $phone');
    return true;
  }
}
