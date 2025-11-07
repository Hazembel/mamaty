

//import 'package:flutter/foundation.dart';
class Article {
  String? id;
  String title;
  List<String> description;
  List<String>? sources;
  List<String> imageUrl;
  List<String> likes;
  List<String> dislikes;
  String category;
  DateTime createdAt; // <-- add this

  Article({
    this.id,
    required this.title,
    required this.description,
    this.sources,
    required this.imageUrl,
    List<String>? likes,
    List<String>? dislikes,
    required this.category,
    required this.createdAt, // <-- required
  })  : likes = likes ?? [],
        dislikes = dislikes ?? [];

factory Article.fromJson(Map<String, dynamic> json) {
  final rawCreatedAt = json['createdAt'];
  DateTime parsedCreatedAt;

  if (rawCreatedAt != null) {
    parsedCreatedAt = DateTime.tryParse(rawCreatedAt)?.toLocal() ?? DateTime.now();
  } else {
    parsedCreatedAt = DateTime.now();
  }

  // 🔹 DEBUG
  //debugPrint('🔹 Article "${json['title']}" createdAt from API: $rawCreatedAt');
 // debugPrint('🔹 Parsed createdAt: $parsedCreatedAt');

  return Article(
    id: json['_id'],
    title: json['title'] ?? '',
    description: List<String>.from(json['description'] ?? []),
    sources: json['sources'] != null ? List<String>.from(json['sources']) : [],
    imageUrl: List<String>.from(json['imageUrl'] ?? []),
    likes: List<String>.from(json['likes'] ?? []),
    dislikes: List<String>.from(json['dislikes'] ?? []),
    category: json['category'] ?? '',
    createdAt: parsedCreatedAt,
  );
}


  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'sources': sources,
        'imageUrl': imageUrl,
        'likes': likes,
        'dislikes': dislikes,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };
}
