// lib/models/doctor.dart
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String city; // was 'distance', now represents city or location
  final String imageUrl;

  // 🆕 Added fields for the details page
  final String description; // bio / about section
  final String workTime; // e.g. "Mon–Fri: 9am–6pm"
  final String phone; // contact number
  final String address; // clinic address

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.city,
    required this.imageUrl,
    required this.description,
    required this.workTime,
    required this.phone,
    required this.address,
  });

  // ✅ Helper: create from Map (for JSON or mock data)
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      city: map['city'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      workTime: map['workTime'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // ✅ Helper: convert to Map (for storage or API)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'city': city,
      'imageUrl': imageUrl,
      'description': description,
      'workTime': workTime,
      'phone': phone,
      'address': address,
    };
  }
}
