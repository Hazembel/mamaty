import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/article_service.dart';

class ArticleProvider extends ChangeNotifier {
  final List<Article> _articles = [];
  bool _isLoading = false;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  /// 🔹 Load all articles (with refresh every time)
  Future<void> loadArticles({int? ageInDays, String? babyId}) async {
  _isLoading = true;
  notifyListeners();

  try {
    final fetchedArticles =
        await ArticleService.getArticles(ageInDays: ageInDays, babyId: babyId);

    _articles
      ..clear()
      ..addAll(fetchedArticles);
  } catch (e) {
    debugPrint('❌ Failed to load articles: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// 🔹 Add a new article
  void addArticle(Article article) {
    if (!_articles.any((a) => a.id == article.id)) {
      _articles.insert(0, article); // newest first
      notifyListeners();
    }
  }

  /// 🔹 Update an existing article
  void updateArticle(Article updatedArticle) {
    final index = _articles.indexWhere((a) => a.id == updatedArticle.id);
    if (index != -1) {
      _articles[index] = updatedArticle;
      notifyListeners();
    }
  }

  /// 🔹 Remove article
  void removeArticle(String articleId) {
    _articles.removeWhere((a) => a.id == articleId);
    notifyListeners();
  }

  /// 🔹 Like / Dislike an article
  Future<void> voteArticle(Article article, String userId, String type) async {
    try {
      final updatedArticle = await ArticleService.voteArticle(
        articleId: article.id!,
        userId: userId,
        type: type,
      );

      // Update local version
      final index = _articles.indexWhere((a) => a.id == article.id);
      if (index != -1) {
        _articles[index] = updatedArticle;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to vote article: $e');
    }
  }

  /// 🔹 Force manual refresh (e.g. pull-to-refresh)
  Future<void> refreshArticles() async {
    debugPrint('🔁 Refreshing articles...');
    _articles.clear();
    await loadArticles();
  }
}
