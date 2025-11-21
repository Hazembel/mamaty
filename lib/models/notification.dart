// models/notification.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? articleId; // if it’s linked to an article
  final String? recipeId;  // if it’s linked to a recipe
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.articleId,
    this.recipeId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      articleId: json['article']?['_id'],
      recipeId: json['recipe']?['_id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
