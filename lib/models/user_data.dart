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
  List<BabyProfileData> babies = [];

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
  }) {
    this.babies = babies ?? [];
  }

  // ✅ Quick helper
  bool get isNewUser => babies.isEmpty;
}
