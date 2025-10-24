class ForgetpasswordData {
  String? phone;
  String? otpCode;
  String? password; 

  ForgetpasswordData({
    this.phone,
    this.otpCode,
    this.password, 
  });

  @override
  String toString() {
    return 'ForgetpasswordData(phone: $phone, otpCode: $otpCode, password: ${password != null ? "***" : null} )';
  }
}
