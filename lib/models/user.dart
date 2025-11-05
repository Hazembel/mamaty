class User {
  String id;
  String name;
  String lastname;
  String email;
  String phone;
  String avatar;
  String gender;
  String birthday;
  List<String> babies;   // IDs
  List<String> doctors;  // ✅ Added for favorite doctors
  String? token;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.gender,
    required this.birthday,
    required this.babies,
    required this.doctors, // ✅ add in constructor
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      gender: json['gender'],
      birthday: json['birthday'],
      babies: List<String>.from(json['babies'] ?? []),
      doctors: List<String>.from(json['doctors'] ?? []), // ✅ parse doctors
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'gender': gender,
      'birthday': birthday,
      'babies': babies,
      'doctors': doctors, // ✅ include doctors
      'token': token,
    };
  }
}
