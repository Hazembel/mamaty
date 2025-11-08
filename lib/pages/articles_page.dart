import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/article.dart';
import '../widgets/app_article_box.dart';
import '../providers/article_provider.dart';
import '../providers/baby_provider.dart';
import '../widgets/app_trending_article.dart';
import 'article_detail_page.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../theme/colors.dart';
 
import '../theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../utils/date_utils.dart';

class ArticlesPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;

  const ArticlesPage({
    super.key,
    this.title = 'Articles',
    this.searchPlaceholder = 'Rechercher un article',
    this.onBack,
  });

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  Article? _trendingArticle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);

    try {
      final babyProvider = context.read<BabyProvider>();
      final selectedBaby = babyProvider.selectedBaby;

      int? ageInDays;
      String? babyId;

      if (selectedBaby != null) {
        ageInDays = DateUtilsHelper.calculateAgeInDays(selectedBaby.birthday);
        babyId = selectedBaby.id;
      }

      final articleProvider = context.read<ArticleProvider>();
      await articleProvider.loadArticles(ageInDays: ageInDays, babyId: babyId);

      setState(() {
        _allArticles = articleProvider.articles;
        _filteredArticles = _allArticles;
        _trendingArticle = _allArticles.isNotEmpty ? _allArticles[0] : null;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Failed to load articles: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredArticles = _allArticles
          .where((a) => a.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openArticleDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: CustomScrollView(
          clipBehavior: Clip.none, // ✅ Added here
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTopBarText(
                    title: widget.title,
                    onBack:
                        widget.onBack ??
                        () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                  ),
                  const SizedBox(height: 15),
                  AppSearchInput(
                    showFilterButton: false,
                    searchText: widget.searchPlaceholder,
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 15),
                  if (_trendingArticle != null) ...[
                    Text(
                      'Trending article',
                      style: AppTextStyles.inter16SemiBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppTrendingArticle(
                      title: _trendingArticle!.title,
                      imageUrl: _trendingArticle!.imageUrl.first,
                      tags: [_trendingArticle!.category],
                      onTap: () => _openArticleDetail(_trendingArticle!),
                      onReadTap: () => _openArticleDetail(_trendingArticle!),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Derniers articles',
                      style: AppTextStyles.inter16SemiBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ],
              ),
            ),
            // 🔹 Loading shimmer
            if (_isLoading)
              SliverPadding(
                padding: const EdgeInsets.only(top: 10),
                sliver: SliverList.builder(
                  itemCount: 6,
                  itemBuilder: (_, __) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (_filteredArticles.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: const Center(child: Text('Aucun article trouvé.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverList.builder(
                  itemCount: _filteredArticles.skip(1).length,
                  itemBuilder: (context, index) {
                    final article = _filteredArticles.skip(1).toList()[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: AppArticleBox(
                        title: article.title,
                        imageUrl: article.imageUrl.first,
                        category: article.category,
                        timeAgo: _getTimeAgo(article.createdAt),
                        onTap: () => _openArticleDetail(article),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours} heures';
    } else {
      return 'il y a ${difference.inDays} jours';
    }
  }
}
