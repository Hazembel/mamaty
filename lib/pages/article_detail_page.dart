import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
 
import '../models/article.dart';
import '../providers/article_provider.dart';
import '../providers/user_provider.dart';
 import 'package:share_plus/share_plus.dart';
import '../widgets/app_row_likedislike.dart';
import '../widgets/app_article_box.dart';
import '../widgets/app_snak_bar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../services/article_service.dart';
//immport top bar
import '../widgets/app_top_bar_text.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late Article _article;
  bool _isLoading = true; // shimmer loading state
  bool _isSaving = false; // ✅ Add this
  bool _isSaved = false; // ✅ Track favorite state
@override
void initState() {
  super.initState();
  _article = widget.article;

  // ✅ Register view silently
  _registerView();

  Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  });
}


Future<void> _registerView() async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    if (userId == null) return;

    // Call backend endpoint to register view
    await ArticleService.viewArticle(_article.id!);
  } catch (e) {
    debugPrint('Failed to register article view: $e');
  }
}




Future<void> _toggleFavorite(UserProvider userProvider) async {
  final articleId = widget.article.id;
  if (articleId == null) return;

  // ✅ Optimistic update: toggle locally immediately
  final previousState = _isSaved;
  setState(() => _isSaved = !_isSaved);

  try {
    debugPrint('🔹 Calling backend to toggle favorite article $articleId...');

    // Call backend asynchronously
    await ArticleService.toggleFavoriteArticle(articleId);

    // Update provider after backend succeeds
    await userProvider.toggleFavoriteArticle(articleId);

    if (!mounted) return;

    AppSnackBar.show(
      context,
      message: _isSaved
          ? "L'article a été ajouté aux favoris ❤️"
          : "L'article a été retiré des favoris 💔",
    );

    debugPrint(
      '💾 Favorite articles after toggle: ${userProvider.user?.articles}',
    );
  } catch (e) {
    debugPrint('❌ Failed to toggle favorite article: $e');

    // Rollback UI if backend fails
    if (mounted) setState(() => _isSaved = previousState);

    AppSnackBar.show(
      context,
      message: "Impossible de modifier les favoris.",
      backgroundColor: Colors.redAccent,
    );
  }
}

  Future<void> _vote(String type, String userId) async {
    try {
      final updatedArticle = await ArticleService.voteArticle(
        articleId: _article.id!,
        userId: userId,
        type: type,
      );
      if (!mounted) return;

      setState(() {
        _article.likes = updatedArticle.likes;
        _article.dislikes = updatedArticle.dislikes;
      });

      final message = type == 'like'
          ? "Vous avez aimé cet article 👍"
          : "Vous n'avez pas aimé cet article 👎";
      AppSnackBar.show(context, message: message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: "Impossible de voter pour le moment",
        backgroundColor: Colors.redAccent,
      );
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 220, width: double.infinity, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 20, width: 200, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 14, width: 150, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 220, width: double.infinity, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 50, width: double.infinity, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final articleProvider = context.watch<ArticleProvider>();
    final currentUserId = userProvider.user?.id;

    final related = articleProvider.articles
        .where((a) => a.id != _article.id)
        .take(3)
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: _buildShimmer(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top image + AppTopBar
                  Stack(
                    children: [
                      if (_article.imageUrl.isNotEmpty)
                        SizedBox(
                          height: 290,
                          width: double.infinity,
                          child: Image.network(
                            _article.imageUrl.first,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 290,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                     Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: AppTopBarText(
        title: '',
        showBack: true,
        showShare: true,
        showSave: true,
        isSaved: _isSaved,
        onBack: () => Navigator.of(context).pop(),
        onShare: () async {
          final shareText = StringBuffer()
            ..write("📖 Découvrez cet article : ")
            ..write(_article.title)
            ..write("\n\n")
            ..write(
              _article.description.isNotEmpty
                  ? _article.description.first
                  : '',
            )
            ..write("\n\n")
            ..write("Catégorie : ${_article.category}")
            ..write("\n\n")
            ..write("Lisez-le maintenant !");
          await SharePlus.instance.share(
            ShareParams(
              text: shareText.toString(),
              title: 'Partager cet article',
            ),
          );
        },
        onToggleSave: () => _toggleFavorite(userProvider),
      ),
    ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _article.title,
                          style: AppTextStyles.inter16SemiBold.copyWith(
                            color: AppColors.premier,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_article.category} • ${formatTimeAgo(_article.createdAt)}',
                              style: AppTextStyles.inter12Med.copyWith(
                                color: AppColors.premier,
                              ),
                            ),
                            Text(
                              _article.sources != null && _article.sources!.isNotEmpty
                                  ? _article.sources!.join(' • ')
                                  : '',
                              style: AppTextStyles.inter12Med.copyWith(
                                color: AppColors.premier,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (_article.description.isNotEmpty)
                          Text(
                            _article.description.first,
                            style: AppTextStyles.inter12Med.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Additional images
                        if (_article.imageUrl.length > 1)
                          ..._article.imageUrl.sublist(1).map(
                            (img) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.network(
                                    img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Text(' '),
                          ),
                        const SizedBox(height: 10),

                        if (_article.description.length > 1)
                          Text(
                            _article.description[1],
                            style: AppTextStyles.inter12Med.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Like/Dislike row using model
                        if (currentUserId != null)
                          AppRowLikeDislike(
                            titletext: 'Cet article est-il utile ?',
                            isLiked: _article.isLikedBy(currentUserId),
                            isDisliked: _article.isDislikedBy(currentUserId),
                            onLike: () => _vote('like', currentUserId),
                            onDislike: () => _vote('dislike', currentUserId),
                          )
                        else
                          const Text(
                            'Connectez-vous pour voter',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Related articles
                        if (related.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'En rapport',
                                style: AppTextStyles.inter16SemiBold.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children: related
                                    .map(
                                      (a) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: AppArticleBox(
                                          title: a.title,
                                          imageUrl: a.imageUrl.isNotEmpty
                                              ? a.imageUrl.first
                                              : '',
                                          category: a.category,
                                          timeAgo: formatTimeAgo(a.createdAt),
                                          onTap: () => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ArticleDetailPage(article: a),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
