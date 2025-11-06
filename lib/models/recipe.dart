class Ingredient {
  String name;
  double quantity;
  String unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'unit': unit,
      };
}

class Recipe {
  String? id;
  String title;
  String description;
  List<Ingredient> ingredients;
  List<String> instructions;
  String imageUrl;
  String? videoUrl;
  String category;
  String? city;
  List<String> sources;
  List<String> likes;
  List<String> dislikes;
  double rating;
  int minDay;
  int maxDay;

  bool? isFavorite; // ✅ added to track favorite locally

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    this.videoUrl,
    required this.category,
    this.city,
    List<String>? sources,
    List<String>? likes,
    List<String>? dislikes,
    required this.rating,
    this.minDay = 270, // 9 months
    this.maxDay = 720, // 24 months
    this.isFavorite,   // ✅ initialize
  })  : likes = likes ?? [],
        dislikes = dislikes ?? [],
        sources = sources ?? [];

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e))
              .toList() ??
          [],
      instructions: List<String>.from(json['instructions'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      videoUrl: json['videoUrl'],
      category: json['category'] ?? '',
      city: json['city'],
      sources: List<String>.from(json['sources'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      minDay: json['minDay'] ?? 270,
      maxDay: json['maxDay'] ?? 720,
      isFavorite: json['isFavorite'], // ✅ parse from API if available
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'instructions': instructions,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'category': category,
        'city': city,
        'sources': sources,
        'likes': likes,
        'dislikes': dislikes,
        'rating': rating,
        'minDay': minDay,
        'maxDay': maxDay,
        'isFavorite': isFavorite, // ✅ include in JSON
      };

  int get likeCount => likes.length;
  int get dislikeCount => dislikes.length;
  bool isLikedBy(String userId) => likes.contains(userId);
  bool isDislikedBy(String userId) => dislikes.contains(userId);
}
