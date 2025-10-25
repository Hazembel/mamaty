import '../data/test_login_data.dart';
import 'dart:math';
import 'dart:developer' as developer;
 import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_data.dart';
import '../models/user_data.dart';

UserData? currentUser;


class AuthService {

  /// Simulates an API login call using test data.
  
  
  /// Returns the TestUser if credentials match, null otherwise.
  
  //********* LOGIN *********//  

Future<LoginData?> login({
  required String phone,
  required String password,
}) async {
  await Future.delayed(const Duration(milliseconds: 500));

  for (final user in testUsers) {
    if (user.phone == phone && user.password == password) {
      // ✅ Simulate a token
      final token = 'token_${user.phone}_${DateTime.now().millisecondsSinceEpoch}';

      // ✅ Create login data
      final loginData = LoginData(
        phone: phone,
        password: password,
        token: token,
      );
      await _saveLoginData(loginData);

      // ✅ Fill user data (normally this would come from API)
      final userData = UserData(
        name: user.name,
        lastname: user.lastname,
        phone: user.phone,
        email: user.email,
        avatar: user.avatar,
        gender: user.gender,
        birthday: user.birthday,
        token: token,
        babies: user.babies, // if test user already has babies
      );

      // 💾 You can store it in memory or local storage for access later
      currentUser = userData;

      return loginData;
    }
  }
  return null;
}
  Future<void> _saveLoginData(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_phone', data.phone ?? '');
    await prefs.setString('login_token', data.token ?? '');
  }

  Future<LoginData?> loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('login_phone');
    final token = prefs.getString('login_token');
    if (phone != null && phone.isNotEmpty && token != null && token.isNotEmpty) {
      return LoginData(phone: phone, token: token);
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_phone');
    await prefs.remove('login_token');
  }

//********** FORGET PASSWORD *****/

  /// Simulates verifying if a phone number exists in test data (for login)
  Future<String?> forgetPassVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (!exists) return null;

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];

    developer.log('📱 [Test] Sending login code $code to $phone');
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
      developer.log('❌ [Test] User not found for password creation: $phone');
      return false;
    }

    // Update password in simulated data
    testUsers[userIndex] = testUsers[userIndex].copyWith(password: password);

    developer.log('🔐 [Test] Password successfully created for $phone');
    return true;
  }


//************* SIGN UP **********/

  /// Simulates verifying if a phone number can be used to sign up
  Future<String?> signupVerifyPhoneSendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final exists = testUsers.any((user) => user.phone == phone);
    if (exists) {
      developer.log('🚫 [Test] Phone already registered: $phone');
      return null;
    }

    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];
    developer.log('📱 [Test] Sending signup code $code to $phone');
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
    developer.log('❌ [Test] Cannot create user, phone already exists: $phone');
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

  developer.log('✅ [Test] User created: $phone');
  return true;
}

}
