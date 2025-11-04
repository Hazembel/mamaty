class Advice {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String category; // "nutrition", "sleep", "care", etc.
  final int? day;        // For 0–6 months specific days
  final int? minDay;     // Minimum age in days (for range advices)
  final int? maxDay;     // Maximum age in days (for range advices)

  Advice({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.day,
    this.minDay,
    this.maxDay,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      day: json['day'],
      minDay: json['minDay'],
      maxDay: json['maxDay'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'day': day,
        'minDay': minDay,
        'maxDay': maxDay,
      };
}
