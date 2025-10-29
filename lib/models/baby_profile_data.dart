class BabyProfileData {
  String? name;
  String? birthday;
  String? gender;
  String? avatar;
  String? parentphone;
  double? height;
  double? weight;
  String? disease; 
  String? allergy;
  int? headSize;
  bool autorisation = true;


  BabyProfileData({
    this.name,
    this.birthday,
    this.gender,
    this.avatar,
    this.parentphone,
    this.height,
    this.weight,
    this.disease,
    this.allergy,
this.headSize,
this.autorisation = true,
  });

  factory BabyProfileData.fromJson(Map<String, dynamic> json) =>
      BabyProfileData(
        name: json['name'],
        birthday: json['birthday'],
        gender: json['gender'],
        avatar: json['avatar'],
        parentphone: json['parentphone'],
        height: (json['height'] != null) ? json['height'].toDouble() : null,
        weight: (json['weight'] != null) ? json['weight'].toDouble() : null,
        disease: json['disease'],
        allergy: json['allergy'],
        headSize: json['headSize'],
        autorisation: json['autorisation'] ?? true,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'birthday': birthday,
    'gender': gender,
    'height': height,
    'avatar': avatar,
    'parentphone': parentphone,
    'weight': weight,
    'disease': disease,
    'allergy': allergy,
    'headSize': headSize,
    'autorisation': autorisation,
  };

  @override
  String toString() {
    return 'BabyProfileData(name: $name, birthday: $birthday, height: $height, gender: $gender, avatar: $avatar, parentphone: $parentphone, weight: $weight, disease: $disease , allergy: $allergy, headSize: $headSize , autorisation: $autorisation )';
  }
}
