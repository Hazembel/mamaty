class Advice {
  String? id;
  String title;
  List<String> description;
  List<String>? sources;
  List<String> imageUrl;
  List<String> likes;     // user IDs
  List<String> dislikes;  // user IDs
  String category;
  int? day;
  int? minDay;
  int? maxDay;

  Advice({
    this.id,
    required this.title,
    required this.description,
    this.sources,
    required this.imageUrl,
    List<String>? likes,
    List<String>? dislikes,
    required this.category,
    this.day,
    this.minDay,
    this.maxDay,
  })  : likes = likes ?? [],
        dislikes = dislikes ?? [];

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['_id'],
      title: json['title'] ?? '',
      description: List<String>.from(json['description'] ?? []),
      sources: List<String>.from(json['sources'] ?? []),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      category: json['category'] ?? '',
      day: json['day'],
      minDay: json['minDay'],
      maxDay: json['maxDay'],
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
        'day': day,
        'minDay': minDay,
        'maxDay': maxDay,
      };

  int get likeCount => likes.length;
  int get dislikeCount => dislikes.length;
  bool isLikedBy(String userId) => likes.contains(userId);
  bool isDislikedBy(String userId) => dislikes.contains(userId);
}
