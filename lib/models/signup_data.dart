class SignupData {
  String? avatar;
  String? gender;
  String? birthday;
  String? name;
  String? lastname;
  String? phone;
  String? email;
  String? password;
  String? otpCode;
  String? token;

  SignupData();

  /// Copy constructor for editing an existing user
  SignupData.fromUser(SignupData user) {
    avatar = user.avatar;
    gender = user.gender;
    birthday = user.birthday;
    name = user.name;
    lastname = user.lastname;
    phone = user.phone;
    email = user.email;
    password = user.password;
    otpCode = user.otpCode;
    token = user.token;
  }

  /// Optional: helper to convert to JSON (for API calls)
  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'gender': gender,
        'birthday': birthday,
        'name': name,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'password': password,
        'otpCode': otpCode,
        'token': token,
      };
}
