import '../models/baby_profile_data.dart';

class TestUser {
  final String phone;
  final String password;
  final String name;
  final String? lastname;
  final String? email;
  final String? avatar;
  final String? gender;
  final String? birthday;
  final String? otpCode;
  final List<BabyProfileData> babies; // ✅ new

  TestUser({
    required this.phone,
    required this.password,
    required this.name,
    this.lastname,
    this.email,
    this.avatar,
    this.gender,
    this.birthday,
    this.otpCode,
    this.babies = const [], // ✅ default empty list
  });

  TestUser copyWith({
    String? phone,
    String? password,
    String? name,
    String? lastname,
    String? email,
    String? avatar,
    String? gender,
    String? birthday,
    String? otpCode,
    List<BabyProfileData>? babies,
  }) {
    return TestUser(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      otpCode: otpCode ?? this.otpCode,
      babies: babies ?? this.babies,
    );
  }
}

/// ✅ Example test users with babies
final List<TestUser> testUsers = <TestUser>[
  TestUser(
    phone: '123',
    password: '123',
    name: 'Alice',
    lastname: 'Dupont',
    email: 'alice@example.com',
    gender: 'femme',
    birthday: '1995-03-10',
    avatar: 'assets/avatars/mom1.png',
    babies: [
      BabyProfileData(
        name: 'Léo',
        birthday: '2022-06-12',
        gender: 'garçon',
        avatar: 'assets/babies/baby1.png',
        parentphone: '123',
      ),
      BabyProfileData(
        name: 'Emma',
        birthday: '2024-02-05',
        gender: 'fille',
        avatar: 'assets/babies/baby2.png',
        parentphone: '123',
      ),
    ],
  ),
  TestUser(
    phone: '98500200',
    password: 'azerty',
    name: 'Bob',
    lastname: 'Martin',
    email: 'bob@example.com',
    gender: 'homme',
    birthday: '1990-11-02',
    avatar: 'assets/avatars/dad1.png',
    babies: [
      BabyProfileData(
        name: 'Lucas',
        birthday: '2021-08-15',
        gender: 'garçon',
        avatar: 'assets/babies/baby3.png',
        parentphone: '98500200',
      ),
    ],
  ),
  TestUser(
    phone: '99900900',
    password: 'motdepasse',
    name: 'Charlie',
    lastname: 'Durand',
    email: 'charlie@example.com',
    gender: 'homme',
    birthday: '1988-05-25',
    avatar: 'assets/avatars/dad2.png',
    babies: [],
  ),
];

/// ✅ Test OTP codes for simulation
const testCodes = ['1234', '4321', '9876', '2468', '1357'];
