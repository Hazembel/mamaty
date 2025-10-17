class AuthService {
  /// Simulates a network login. Accepts any phone with password 'password' or '123456' as valid.
  static Future<bool> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password == 'password' || password == '123456') return true;
    return false;
  }
}
