class BabyProfileData {
  String? name;
  String? birthday;
  String? gender;
  String? avatar;
  String? parentphone;
    double? height; // ✅ new fiel

  BabyProfileData({
    this.name,
    this.birthday,
    this.gender,
    this.avatar,
    this.parentphone,
    this.height
  });

  factory BabyProfileData.fromJson(Map<String, dynamic> json) => BabyProfileData(
        name: json['name'],
        birthday: json['birthday'],
        gender: json['gender'],
        avatar: json['avatar'],
        parentphone: json['parentphone'],
     height: (json['height'] != null) ? json['height'].toDouble() : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthday': birthday,
        'gender': gender,
         'height': height,
        'avatar': avatar,
        'parentphone': parentphone,
      };

  @override
  String toString() {
    return 'BabyProfileData(name: $name, birthday: $birthday,height: $height, gender: $gender,  avatar: $avatar, parentphone: $parentphone)';
  }
}
