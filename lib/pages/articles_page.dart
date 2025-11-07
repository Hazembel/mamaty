import 'package:flutter/material.dart';
import '../models/article.dart';
 
import '../widgets/app_article_box.dart';
import '../providers/article_provider.dart';
import '../providers/baby_provider.dart';
import '../widgets/app_trending_article.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
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
  String _searchQuery = '';
  List<Article> _articles = [];
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
    // 🔹 Get selected baby from BabyProvider
    final babyProvider = context.read<BabyProvider>();
    final selectedBaby = babyProvider.selectedBaby;

    int? ageInDays;
    String? babyId;

    if (selectedBaby != null) {
      
      ageInDays =  DateUtilsHelper.calculateAgeInDays(selectedBaby.birthday); 
     
      babyId = selectedBaby.id;
      //debugPrint('🔹 Loading articles for baby ${selectedBaby.name}, age: $ageInDays days');
    } else {
    //  debugPrint('ℹ️ No selected baby, loading all articles');
    }

    // 🔹 Load articles via ArticleProvider or directly from service
    final articleProvider = context.read<ArticleProvider>();
    await articleProvider.loadArticles(ageInDays: ageInDays, babyId: babyId);

    setState(() {
      _articles = articleProvider.articles;
      _trendingArticle = _articles.isNotEmpty ? _articles[0] : null;
      _isLoading = false;
    });
  } catch (e) {
    debugPrint('❌ Failed to load articles: $e');
    setState(() => _isLoading = false);
  }
}



  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    // Filter articles based on search query
    _filterArticles();
  }

  void _filterArticles() {
    // Implement filtering logic here
  }

  void _onFilterTap() {
    // Implement filter modal here
    debugPrint('Filter button tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button and title
              AppTopBarText(
                title: widget.title,
                onBack:
                    widget.onBack ??
                    () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
              ),
              const SizedBox(height: 15),

              // Search bar
              AppSearchInput(
                searchText: widget.searchPlaceholder,
                onChanged: _onSearchChanged,
                onFilterTap: _onFilterTap,
              ),
              const SizedBox(height: 15),
              Text(
                'Trending article',
                style: AppTextStyles.inter16SemiBold.copyWith(
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 15),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadArticles,
                        child: ListView(
                          children: [
                            // Trending article
                            if (_trendingArticle != null) ...[
                              AppTrendingArticle(
                                title: _trendingArticle!.title,
                                imageUrl: _trendingArticle!.imageUrl.first,
                                tags: [_trendingArticle!.category],
                                onTap: () {
                                  // Navigate to article detail
                                },
                                onReadTap: () {
                                  // Navigate to article detail with animation
                                },
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Derniers articles',
                                style: AppTextStyles.inter16SemiBold.copyWith(
                                  color: AppColors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 15),
                            ],

                            // Recent articles list
                            ..._articles
                                .skip(1)
                                .map(
                                  (article) => Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: AppArticleBox(
                                      title: article.title,
                                      imageUrl: article.imageUrl.first,
                                      category: article.category,
                                      timeAgo: _getTimeAgo(article.createdAt),
                                      onTap: () {
                                        // Navigate to article detail
                                      },
                                    ),
                                  ),
                                ),
                          ],
                        ),
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
