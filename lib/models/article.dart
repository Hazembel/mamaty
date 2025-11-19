class Article {
  String? id;
  String title;
  List<String> description;
  List<String>? sources;
  List<String> imageUrl;
  List<String> likes;     // user IDs
  List<String> dislikes;  // user IDs
  String category;
  DateTime createdAt;
  bool isFavorite;        // favorite flag

  Article({
    this.id,
    required this.title,
    required this.description,
    this.sources,
    required this.imageUrl,
    List<String>? likes,
    List<String>? dislikes,
    required this.category,
    required this.createdAt,
    this.isFavorite = false,
  })  : likes = likes ?? [],
        dislikes = dislikes ?? [];

  factory Article.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['createdAt'];
    DateTime parsedCreatedAt = rawCreatedAt != null
        ? DateTime.tryParse(rawCreatedAt)?.toLocal() ?? DateTime.now()
        : DateTime.now();

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
      isFavorite: json['isFavorite'] ?? false,
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
        'isFavorite': isFavorite,
      };

  // ✅ getters and helpers like Advice model
  int get likeCount => likes.length;
  int get dislikeCount => dislikes.length;
  bool isLikedBy(String userId) => likes.contains(userId);
  bool isDislikedBy(String userId) => dislikes.contains(userId);
}
