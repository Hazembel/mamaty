// lib/data/test_login_data.dart
class TestUser {
  final String phone;
  final String password;
  final String name;

  const TestUser({
    required this.phone,
    required this.password,
    required this.name,
  });
}

const testUsers = <TestUser>[
  TestUser(phone: '01234567', password: 'password123', name: 'Alice'),
  TestUser(phone: '98500200', password: 'azerty', name: 'Bob'),
  TestUser(phone: '99900900', password: 'motdepasse', name: 'Charlie'),
];
const testCodes = ['1234', '4321', '9876', '2468', '1357'];