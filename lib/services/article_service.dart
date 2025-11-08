import 'dart:convert';
import '../api/api_helper.dart';
import '../models/article.dart';
import 'package:flutter/foundation.dart';

class ArticleService {
  /// ✅ Get all articles (optionally filter by category)
static Future<List<Article>> getArticles({
  int? ageInDays,
  String? babyId,
}) async {
  final queryParams = <String, dynamic>{};
  if (ageInDays != null) queryParams['ageInDays'] = ageInDays.toString();
  if (babyId != null) queryParams['babyId'] = babyId;

  // Build query string dynamically
  final queryString = queryParams.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
      .join('&');

  final endpoint = queryString.isEmpty ? '/articles' : '/articles?$queryString';

  final response = await ApiHelper.get(endpoint);
  //debugPrint('🔹 Articles API response: ${response.body}');

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
   // debugPrint('🔹 Parsed articles length: ${data.length}');
    return data.map((json) => Article.fromJson(json)).toList();
  } else {
  //  debugPrint('❌ Failed to load articles, status: ${response.statusCode}');
    return [];
  }
}



  /// ✅ Create new article (admin/protected)
  static Future<Article> createArticle(Article article) async {
    final response = await ApiHelper.post('/articles', article.toJson());
    if (response.statusCode == 201) {
      final createdArticle = Article.fromJson(jsonDecode(response.body));
      debugPrint('✅ Created article: ${createdArticle.id}');
      return createdArticle;
    } else {
      throw Exception('Failed to create article: ${response.statusCode}');
    }
  }

  /// ✅ Update article by ID (admin/protected)
  static Future<Article> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiHelper.put('/articles/$articleId', updates);
    if (response.statusCode == 200) {
      final updatedArticle = Article.fromJson(jsonDecode(response.body));
      debugPrint('✅ Updated article: ${updatedArticle.id}');
      return updatedArticle;
    } else {
      throw Exception('Failed to update article: ${response.statusCode}');
    }
  }

  /// ✅ Delete article by ID (admin/protected)
  static Future<void> deleteArticle(String articleId) async {
    final response = await ApiHelper.delete('/articles/$articleId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete article: ${response.statusCode}');
    }
    debugPrint('🗑️ Deleted article $articleId');
  }

  /// ✅ Vote (like/dislike) an article
  static Future<Article> voteArticle({
    required String articleId,
    required String userId,
    required String type, // 'like' or 'dislike'
  }) async {
    final response = await ApiHelper.post('/articles/$articleId/vote', {
      'userId': userId,
      'type': type,
    });

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to vote article: ${response.statusCode}');
    }
  }

  static Future<bool> toggleFavoriteArticle(String articleId) async {
    final response = await ApiHelper.post('/users/favorite-article/$articleId', {});
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isFavorite']; // <-- backend returns the new favorite state
    } else {
      throw Exception('Failed to toggle favorite article');
    }
  }
}
