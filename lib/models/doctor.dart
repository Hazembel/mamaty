class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String city;
  final String imageUrl;
  final String description;
  final String workTime;
  final String phone;
  final String address;

  bool? isFavorite; // <-- added to track favorite state

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.city,
    required this.imageUrl,
    required this.description,
    required this.workTime,
    required this.phone,
    required this.address,
    this.isFavorite,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      city: map['city'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      workTime: map['workTime'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'city': city,
      'imageUrl': imageUrl,
      'description': description,
      'workTime': workTime,
      'phone': phone,
      'address': address,
      'isFavorite': isFavorite ?? false,
    };
  }
}
