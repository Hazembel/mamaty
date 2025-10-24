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
  });

  /// Helpful copyWith so we can create a modified copy.
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
    );
  }
}

/// Make the list mutable so we can add/update users.
final List<TestUser> testUsers = <TestUser>[
  TestUser(phone: '123', password: '123', name: 'Alice'),
  TestUser(phone: '98500200', password: 'azerty', name: 'Bob'),
  TestUser(phone: '99900900', password: 'motdepasse', name: 'Charlie'),
];

/// Test OTP codes for simulation
const testCodes = ['1234', '4321', '9876', '2468', '1357'];
