import 'baby_profile_data.dart';

class UserData {
  String? avatar;
  String? gender;
  String? birthday;
  String? name;
  String? lastname;
  String? phone;
  String? email;
  String? password;
  String? token;
  List<BabyProfileData> babies;

  UserData({
    this.avatar,
    this.gender,
    this.birthday,
    this.name,
    this.lastname,
    this.phone,
    this.email,
    this.password,
    this.token,
    List<BabyProfileData>? babies,
  }) : babies = babies ?? [];

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        avatar: json['avatar'],
        gender: json['gender'],
        birthday: json['birthday'],
        name: json['name'],
        lastname: json['lastname'],
        phone: json['phone'],
        email: json['email'],
        password: json['password'],
        token: json['token'],
        babies: (json['babies'] as List<dynamic>?)
                ?.map((e) => BabyProfileData.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'gender': gender,
        'birthday': birthday,
        'name': name,
        'lastname': lastname,
        'phone': phone,
        'email': email,
        'password': password,
        'token': token,
        'babies': babies.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return 'UserData(name: $name, lastname: $lastname, phone: $phone, email: $email, token: $token, babies: $babies)';
  }
}
