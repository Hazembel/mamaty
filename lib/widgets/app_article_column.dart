import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';
import '../widgets/app_article_box.dart';
import '../pages/articles_page.dart';
import '../widgets/row_see_more.dart';
import '../utils/date_utils.dart';
import '../providers/baby_provider.dart';

class ArticleRow extends StatefulWidget {
  const ArticleRow({super.key});

  @override
  State<ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<ArticleRow> {
  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

Future<void> _loadArticles() async {
  try {
    // 🔹 Get selected baby from BabyProvider
    final babyProvider = context.read<BabyProvider>();
    final selectedBaby = babyProvider.selectedBaby;

    int? ageInDays;
    String? babyId;

    if (selectedBaby != null) {
      ageInDays = DateUtilsHelper.calculateAgeInDays(selectedBaby.birthday);
      babyId = selectedBaby.id;
      //debugPrint('🔹 Loading articles for baby ${selectedBaby.name}, age: $ageInDays days');
    } else {
     // debugPrint('ℹ️ No selected baby, loading all articles');
    }

    // 🔹 Load articles via ArticleProvider
    final provider = context.read<ArticleProvider>();
    await provider.loadArticles(ageInDays: ageInDays, babyId: babyId);

  } catch (e) {
    debugPrint('❌ Error loading articles: $e');
  }
}


  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Il y a quelques secondes';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} minutes';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} heures';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} jours';
    if (diff.inDays < 30) return 'Il y a ${diff.inDays ~/ 7} semaines';
    if (diff.inDays < 365) return 'Il y a ${diff.inDays ~/ 30} mois';
    return 'Il y a ${diff.inDays ~/ 365} ans';
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

  Widget _buildSkeletonLoader() {
    return Column(
      children: List.generate(
        3,
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
    final articles = provider.articles.take(3).toList();
    final isLoading = provider.isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppRowSeeMore(
            title: 'Meilleurs articles',
            onSeeMore: _openAllArticles,
          ),
          const SizedBox(height: 10),

          if (isLoading)
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
                    imageUrl: article.imageUrl.isNotEmpty
                        ? article.imageUrl.first
                        : '',
                    category: article.category,
                    timeAgo: formatTimeAgo(article.createdAt),
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
