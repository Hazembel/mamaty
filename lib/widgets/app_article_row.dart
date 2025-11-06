import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';
import '../widgets/app_article_box.dart';
import '../pages/articles_page.dart';
import '../widgets/row_see_more.dart';

class ArticleRow extends StatefulWidget {
  const ArticleRow({super.key});

  @override
  State<ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<ArticleRow> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<ArticleProvider>();
      await provider.loadArticles(); // Load all articles
    } catch (e) {
      debugPrint('❌ Error loading articles: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openAllArticles() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ArticlesPage(title: 'Tous les articles'),
      ),
    );
  }

  void _openArticleDetails(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(article.title)),
          body: Center(child: Text('Détails pour: ${article.title}')),
        ),
      ),
    );
  }

  /// Shimmer skeleton for loading
  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(
        3, // Show 3 skeletons vertically
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticleProvider>();
    final articles = provider.articles.take(3).toList(); // show top 3 only

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title + See More
          AppRowSeeMore(
            title: 'Meilleurs articles',
            onSeeMore: _openAllArticles,
          ),
          const SizedBox(height: 10),

          // 🔹 Article list
          if (_isLoading)
            _buildSkeletonLoader()
          else if (articles.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Aucun article trouvé.'),
            )
          else
            Column(
              children: articles.map((article) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppArticleBox(
                    title: article.title,
                    imageUrl: article.imageUrl.isNotEmpty ? article.imageUrl.first : '',
                    category: article.category,
                    timeAgo:  'Il y a 3 heures',
                    onTap: () => _openArticleDetails(article),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
