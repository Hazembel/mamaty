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
  final List<BabyProfileData> babies;

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
    this.babies = const [],
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
  // User with 4 babies (0-6mo, 6-9mo, 9-12mo, + allergy)
  TestUser(
    phone: '123',
    password: '123',
    name: 'Alice',
    lastname: 'Dupont',
    email: 'alice@example.com',
    gender: 'femme',
    birthday: '1995-03-10',
    avatar: 'assets/images/avatars/mom1.jpg',
    babies: [
      // 👶 0–6 months
      BabyProfileData(
        name: 'Léo',
        birthday: '2025-06-10',
        gender: 'garçon',
        avatar: 'assets/images/avatars/baby_boy1.jpg',
        parentphone: '123',
        height: 55,
        weight: 6,
        disease: 'aucune',
        allergy: 'aucune',
        headSize: 38,
        autorisation: true,
      ),

      // 👶 6–9 months
      BabyProfileData(
        name: 'Mila',
        birthday: '2025-02-15',
        gender: 'fille',
        avatar: 'assets/images/avatars/baby_girl1.jpg',
        parentphone: '123',
        height: 68,
        weight: 8,
        disease: 'aucune',
        allergy: 'aucune',
        headSize: 43,
        autorisation: true,
      ),

      // 👶 9–12 months
      BabyProfileData(
        name: 'Noé',
        birthday: '2024-12-05',
        gender: 'garçon',
        avatar: 'assets/images/avatars/baby_boy2.jpg',
        parentphone: '123',
        height: 75,
        weight: 9,
        disease: 'aucune',
        allergy: 'aucune',
        headSize: 45,
        autorisation: true,
      ),

      // 👶 Baby with allergy
      BabyProfileData(
        name: 'Lina',
        birthday: '2024-08-20',
        gender: 'fille',
        avatar: 'assets/images/avatars/baby_girl2.jpg',
        parentphone: '123',
        height: 70,
        weight: 8,
        disease: 'aucune',
        allergy: 'arachides', // 👈 allergy
        headSize: 44,
        autorisation: false, // 👈 automatically false
      ),
    ],
  ),

  // Another test user
  TestUser(
    phone: '98500200',
    password: 'azerty',
    name: 'Bob',
    lastname: 'Martin',
    email: 'bob@example.com',
    gender: 'homme',
    birthday: '1990-11-02',
    avatar: 'assets/images/avatars/dad1.jpg',
    babies: [
      BabyProfileData(
        name: 'Lucas',
        birthday: '2021-08-15',
        gender: 'garçon',
        avatar: 'assets/images/avatars/baby_boy3.jpg',
        parentphone: '98500200',
        height: 60,
        weight: 20,
        disease: 'diabète',
        allergy: 'aucune',
        headSize: 60,
        autorisation: false,
      ),
    ],
  ),

  // Empty test user
  TestUser(
    phone: '99900900',
    password: 'motdepasse',
    name: 'Charlie',
    lastname: 'Durand',
    email: 'charlie@example.com',
    gender: 'homme',
    birthday: '1988-05-25',
    avatar: 'assets/images/avatars/dad2.jpg',
    babies: [],
  ),
];

/// ✅ Test OTP codes for simulation
const testCodes = ['1234', '4321', '9876', '2468', '1357'];
