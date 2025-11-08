import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_row_likedislike.dart';
import '../widgets/app_article_box.dart';
import '../widgets/app_snak_bar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
 
import '../services/article_service.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isLoading = true; // shimmer loading
  bool _isSaving = false; // ✅ Add this
  bool _isSaved = false; // ✅ Track favorite state
  @override
  void initState() {
    super.initState();
    _isLiked = widget.article.likes.contains('local');
    _isDisliked = widget.article.dislikes.contains('local');

    // simulate network delay for shimmer effect
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Future<void> _onVote(String type) async {
    final provider = context.read<ArticleProvider>();
    setState(() {
      if (type == 'like') {
        _isLiked = !_isLiked;
        if (_isLiked) _isDisliked = false;
      } else {
        _isDisliked = !_isDisliked;
        if (_isDisliked) _isLiked = false;
      }
    });
    try {
      await provider.voteArticle(widget.article, 'local', type);
      if (!mounted) return;
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Future<void> _toggleFavorite(UserProvider userProvider) async {
    final articleId = widget.article.id;
    if (articleId == null) return;

    setState(() => _isSaving = true);

    try {
      debugPrint('🔹 Calling backend to toggle favorite article $articleId...');

      // Call backend (no named parameter)
      await ArticleService.toggleFavoriteArticle(articleId);

      debugPrint('🔹 Backend call completed, updating provider...');

      // Update provider
      await userProvider.toggleFavoriteArticle(articleId);

      // Update local UI state
      final isSaved = userProvider.user?.articles.contains(articleId) ?? false;
      setState(() {
        _isSaved = isSaved;
      });

      if (!mounted) return;

      AppSnackBar.show(
        context,
        message: isSaved
            ? "L'article a été ajouté aux favoris ❤️"
            : "L'article a été retiré des favoris 💔",
      );

      debugPrint(
        '💾 Favorite articles after toggle: ${userProvider.user?.articles}',
      );
    } catch (e) {
      debugPrint('❌ Failed to toggle favorite article: $e');
      if (!mounted) return;

      AppSnackBar.show(
        context,
        message: "Impossible de modifier les favoris.",
        backgroundColor: Colors.redAccent,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticleProvider>();
    final userProvider = context.watch<UserProvider>();
    final isSaved =
        userProvider.user?.articles.contains(widget.article.id) ?? false;

    final related = provider.articles
        .where((a) => a.id != widget.article.id)
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
                padding:EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            children: [
              AppTopBarText(
                title: '',
                showBack: true,
                showShare: true,
                showSave: true,
                isSaved: isSaved,
                onToggleSave: () => _toggleFavorite(userProvider),
                onShare: () async {
                  final shareText = StringBuffer()
                    ..write("📖 Découvrez cet article : ")
                    ..write(widget.article.title)
                    ..write("\n\n")
                    ..write(
                      widget.article.description.isNotEmpty
                          ? widget.article.description.first
                          : '',
                    )
                    ..write("\n\n")
                    ..write("Catégorie : ${widget.article.category}")
                    ..write("\n\n")
                    ..write("Lisez-le maintenant !");

                   await SharePlus.instance.share(
    ShareParams(
      text: shareText.toString(),
      title: 'Partager cet article', // optional
    ),
  );
                },
                onBack: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: _isLoading
                      ? _buildShimmer()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main image
                            if (widget.article.imageUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  widget.article.imageUrl.first,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: double.infinity,
                                    height: 220,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 15),
                            Text(
                              widget.article.title,
                              style: AppTextStyles.inter16SemiBold.copyWith(
                                color: AppColors.premier,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.article.category} • ${formatTimeAgo(widget.article.createdAt)}',
                                  style: AppTextStyles.inter12Reg.copyWith(
                                    color: AppColors.premier,
                                  ),
                                ),
                                Text(
                                  widget.article.sources != null &&
                                          widget.article.sources!.isNotEmpty
                                      ? widget.article.sources!.join(' • ')
                                      : '',
                                  style: AppTextStyles.inter12Reg.copyWith(
                                    color: AppColors.premier,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            if (widget.article.description.isNotEmpty)
                              Text(
                                widget.article.description[0],
                                style: AppTextStyles.inter12Med.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            const SizedBox(height: 15),
                            for (
                              int i = 1;
                              i < widget.article.description.length &&
                                  i < widget.article.imageUrl.length;
                              i++
                            ) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  widget.article.imageUrl[i],
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: double.infinity,
                                    height: 220,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                widget.article.description[i],
                                style: AppTextStyles.inter14Med.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                            AppRowLikeDislike(
                              titletext: 'Cet article est-il utile ?',
                              isLiked: _isLiked,
                              isDisliked: _isDisliked,
                              onLike: () => _onVote('like'),
                              onDislike: () => _onVote('dislike'),
                            ),
                            const SizedBox(height: 15),
                            if (related.isNotEmpty) ...[
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
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: AppArticleBox(
                                          title: a.title,
                                          imageUrl: a.imageUrl.isNotEmpty
                                              ? a.imageUrl.first
                                              : '',
                                          category: a.category,
                                          timeAgo: formatTimeAgo(a.createdAt),
                                          onTap: () =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ArticleDetailPage(
                                                        article: a,
                                                      ),
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                            const SizedBox(height: 30),
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
}
