class User {
  String id;
  String name;
  String lastname;
  String email;
  String phone;
  String avatar;
  String gender;
  String birthday;
  List<String> babies;    // IDs
  List<String> doctors;   // favorite doctors
  List<String> recipes;   // favorite recipes
  List<String> articles;  // favorite articles ✅
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
    required this.doctors,
    required this.recipes,
    required this.articles, // ✅ initialize articles
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
      doctors: List<String>.from(json['doctors'] ?? []),
      recipes: List<String>.from(json['recipes'] ?? []),
      articles: List<String>.from(json['articles'] ?? []), // ✅ parse articles
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
      'doctors': doctors,
      'recipes': recipes,
      'articles': articles, // ✅ include articles
      'token': token,
    };
  }
}
