class Article {
  String? id;
  String title;
  List<String> description;
  List<String>? sources;
  List<String> imageUrl;
  List<String> likes;     // user IDs
  List<String> dislikes;  // user IDs
  String category;

  Article({
    this.id,
    required this.title,
    required this.description,
    this.sources,
    required this.imageUrl,
    List<String>? likes,
    List<String>? dislikes,
    required this.category,
  })  : likes = likes ?? [],
        dislikes = dislikes ?? [];

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id'],
      title: json['title'] ?? '',
      description: List<String>.from(json['description'] ?? []),
      sources: List<String>.from(json['sources'] ?? []),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      category: json['category'] ?? '',
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
      };

  int get likeCount => likes.length;
  int get dislikeCount => dislikes.length;
  bool isLikedBy(String userId) => likes.contains(userId);
  bool isDislikedBy(String userId) => dislikes.contains(userId);
}
