// lib/models/doctor.dart
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String distance;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.distance,
    required this.imageUrl,
  });
}