class LoginData {
  String? phone;       // user phone
  String? password;    // optional, only if you want to store it securely (e.g., for auto-login)
  String? token;       // API token or session token from backend
  
  LoginData({
    this.phone,
    this.password,
    this.token,
    
  });

  @override
  String toString() {
    return 'LoginData(phone: $phone, password: ${password != null ? "***" : null}, token: $token   )';
  }
}
