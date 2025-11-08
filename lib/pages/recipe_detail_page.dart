import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/recipe.dart';
import '../providers/user_provider.dart';
import '../services/recipe_service.dart';
import '../widgets/app_top_bar_text.dart';
import '../icons/app_icons.dart';
import '../widgets/app_row_likedislike.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../widgets/app_snak_bar.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Recipe _recipe;
  bool isSaved = false;
  bool _isSaving = false;
  bool _isVoting = false;
  int _selectedTab = 0; // 0 = Ingredients, 1 = Instructions

 
@override
void initState() {
  super.initState();
  _recipe = widget.recipe;

  // Initialize isSaved based on user's favorites
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      isSaved = userProvider.user?.recipes.contains(_recipe.id) ?? false;
    });
  });
}

Future<void> _toggleFavorite(UserProvider userProvider) async {
  final recipeId = widget.recipe.id;
  if (recipeId == null) return;

  setState(() => _isSaving = true);

  try {
    // Call backend
    await RecipeService.toggleFavoriteRecipe(recipeId: recipeId);

    // Update provider
    await userProvider.toggleFavoriteRecipe(recipeId);

    // Update the heart icon
    setState(() {
      isSaved = userProvider.user?.recipes.contains(recipeId) ?? false;
    });

    if (!mounted) return;

    // Show success message
    AppSnackBar.show(
      context,
      message: isSaved
          ? "La recette a été ajoutée aux favoris ❤️"
          : "La recette a été retirée des favoris 💔",
    );
  } catch (e) {
    debugPrint('❌ Failed to toggle favorite: $e');
    if (!mounted) return;

    // Show error message
    AppSnackBar.show(
      context,
      message: 'Impossible de modifier les favoris.',
      backgroundColor: Colors.redAccent,
    );
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
}




  void _shareRecipe() async {
    final shareText =
        "Découvrez cette recette: ${_recipe.title} 🍲\nEssayez-la maintenant!";
    await SharePlus.instance.share(
    ShareParams(
      text: shareText.toString(),
      title: 'Partager cet article', // optional
    ),  
    );
  }

  void _openVideo() async {
    if (_recipe.videoUrl != null && _recipe.videoUrl!.isNotEmpty) {
      final url = Uri.parse(_recipe.videoUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Could not open video');
      }
    }
  }

Future<void> _voteRecipe(String type, String userId) async {
  if (_isVoting) return;
  setState(() => _isVoting = true);

  try {
    final updatedRecipe = await RecipeService.voteRecipe(
      recipeId: _recipe.id!,
      userId: userId,
      type: type,
    );
    setState(() {
      _recipe.likes = updatedRecipe.likes;
      _recipe.dislikes = updatedRecipe.dislikes;
    });

    if (!mounted) return;

    // Show success message
    final message = type == 'like'
        ? "Vous avez aimé cette recette 👍"
        : "Vous n'avez pas aimé cette recette 👎";

    AppSnackBar.show(
      context,
      message: message,
    );
  } catch (e) {
    debugPrint('❌ Failed to vote: $e');

    if (!mounted) return;

    // Show error message
    AppSnackBar.show(
      context,
      message: "Impossible de voter pour le moment",
      backgroundColor: Colors.redAccent,
    );
  } finally {
    if (mounted) setState(() => _isVoting = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserId = userProvider.user?.id;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top image with gradient, play button, and AppTopBarText
            Stack(
              children: [
                if (_recipe.imageUrl.isNotEmpty)
                  SizedBox(
                    height: 290,
                    width: double.infinity,
                    child: Image.network(
                      _recipe.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 290,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                Container(
                  height: 290,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.premier.withValues(alpha: 0.95),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                if (_recipe.videoUrl != null && _recipe.videoUrl!.isNotEmpty)
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: _openVideo,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(15),
                          child: AppIcons.svg(
                            AppIcons.play,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: AppDimensions.pagePadding,
                  child: AppTopBarText(
                    showBack: true,
                    showShare: true,
                    showSave: true,
                    onBack: () => Navigator.pop(context),
                    onShare: _shareRecipe,
                    isSaved: isSaved,
                    onToggleSave: _isSaving ? null : () => _toggleFavorite(userProvider),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Padding(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _recipe.title,
                    style: AppTextStyles.inter16SemiBold.copyWith(color: AppColors.premier),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _recipe.category,
                        style: AppTextStyles.inter12Med.copyWith(color: AppColors.premier),
                      ),
                      Text(
                        _recipe.sources.isNotEmpty ? _recipe.sources.join(' • ') : '',
                        style: AppTextStyles.inter12Med.copyWith(color: AppColors.premier),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tabs: Ingredients / Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [AppColors.defaultShadow],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? AppColors.premier : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Ingrédients',
                          style: AppTextStyles.inter16SemiBold.copyWith(
                            color: _selectedTab == 0 ? Colors.white : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? AppColors.premier : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Instructions',
                          style: AppTextStyles.inter16SemiBold.copyWith(
                            color: _selectedTab == 1 ? Colors.white : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Content depending on selected tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _selectedTab == 0
                    ? _recipe.ingredients
                        .map((i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "• ${i.name}",
                                      style: AppTextStyles.inter14Med,
                                    ),
                                  ),
                                  Text(
                                    "${i.quantity} ${i.unit}",
                                    style: AppTextStyles.inter14Med.copyWith(color: AppColors.premier),
                                  ),
                                ],
                              ),
                            ))
                        .toList()
                    : _recipe.instructions
                        .map((s) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text("• $s", style: AppTextStyles.inter14Med),
                            ))
                        .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Like/Dislike Row at the very end
            if (currentUserId != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppRowLikeDislike(
                  titletext: 'Cette recette est-elle utile ?',
                  isLiked: _recipe.isLikedBy(currentUserId),
                  isDisliked: _recipe.isDislikedBy(currentUserId),
                  onLike: () => _voteRecipe('like', currentUserId),
                  onDislike: () => _voteRecipe('dislike', currentUserId),
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
