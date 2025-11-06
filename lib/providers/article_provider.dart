import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/article_service.dart';

class ArticleProvider extends ChangeNotifier {
  final List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  /// Load articles (optionally filtered by category)
 Future<void> loadArticles() async {
  _isLoading = true;
  notifyListeners();

  try {
    final fetchedArticles = await ArticleService.getArticles();
    debugPrint('🔹 Fetched articles from service: ${fetchedArticles.length}'); // <-- add this

    _articles
      ..clear()
      ..addAll(fetchedArticles);

    debugPrint('🔹 Articles after adding to provider: ${_articles.length}');
  } catch (e) {
    debugPrint('❌ Failed to load articles: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// Add new article (admin)
  void addArticle(Article article) {
    if (!_articles.any((a) => a.id == article.id)) {
      _articles.add(article);
      notifyListeners();
    }
  }

  /// Update existing article
  void updateArticle(Article updatedArticle) {
    final index = _articles.indexWhere((a) => a.id == updatedArticle.id);
    if (index != -1) {
      _articles[index] = updatedArticle;
      notifyListeners();
    }
  }

  /// Remove article
  void removeArticle(String articleId) {
    _articles.removeWhere((a) => a.id == articleId);
    notifyListeners();
  }

  /// Vote (like or dislike) an article for a specific user
  Future<void> voteArticle(Article article, String userId, String type) async {
    try {
      final updatedArticle = await ArticleService.voteArticle(
        articleId: article.id!,
        userId: userId,
        type: type,
      );

      // Update local article
      article.likes = updatedArticle.likes;
      article.dislikes = updatedArticle.dislikes;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to vote article: $e');
    }
  }
}
