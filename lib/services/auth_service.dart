import '../data/test_login_data.dart';
import 'dart:math';
import 'dart:developer' as developer;

class AuthService {
  /// Simulates an API login call using test data.
  /// Returns the TestUser if credentials match, null otherwise.
  Future<TestUser?> login({
    required String phone,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    for (final user in testUsers) {
      if (user.phone == phone && user.password == password) {
        return user;
      }
    }
    return null;
  }

/// Simulates verifying if a phone number exists in test data
/// Verify phone and return a random code from testCodes
  Future<String?> loginVerifyPhoneNumber(String phone) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate API delay

    // Check if user exists
    final exists = testUsers.any((user) => user.phone == phone);
    if (!exists) return null;

    // Generate random code
    final random = Random();
    final code = testCodes[random.nextInt(testCodes.length)];

    // Simulate backend sending SMS (for test)
    developer.log('📱 [Test] Sending code $code to $phone');

    return code;
  }


Future<String?> signupVerifyPhoneNumber(String phone) async {
  await Future.delayed(const Duration(milliseconds: 500)); // simulate API delay

  // Check if phone already exists
  final exists = testUsers.any((user) => user.phone == phone);
  if (exists) {
    developer.log('🚫 [Test] Phone already registered: $phone');
    return null; // cannot create new account with existing phone
  }

  // Generate random code
  final random = Random();
  final code = testCodes[random.nextInt(testCodes.length)];

  // Simulate backend sending SMS
  developer.log('📱 [Test] Sending signup code $code to $phone');

  return code;
}





}
