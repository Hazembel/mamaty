import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/filter_chip_box.dart';
import '../widgets/app_top_bar_text.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../providers/user_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/article_provider.dart';
import '../providers/doctor_provider.dart';
import '../models/recipe.dart';
import '../models/article.dart';
import '../models/doctor.dart';
import '../pages/recipe_detail_page.dart';
import '../pages/article_detail_page.dart';
import '../pages/doctor_details_page.dart';
import '../widgets/app_recipe_box.dart';
import '../widgets/app_article_box.dart';
import '../widgets/app_doctor_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String _selectedCategory = 'Recettes';
  final List<String> _categories = ['Recettes', 'Articles', 'Médecins'];

  List<Recipe> _favoriteRecipes = [];
  List<Article> _favoriteArticles = [];
  List<Doctor> _favoriteDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.user;

      if (user != null) {
        final recipeProvider = context.read<RecipeProvider>();
        await recipeProvider.loadRecipes();
        _favoriteRecipes = recipeProvider.recipes
            .where((r) => user.recipes.contains(r.id))
            .toList();

        final articleProvider = context.read<ArticleProvider>();
        await articleProvider.loadArticles();
        _favoriteArticles = articleProvider.articles
            .where((a) => user.articles.contains(a.id))
            .toList();

        final doctorProvider = context.read<DoctorProvider>();
        await doctorProvider.loadDoctors();
        _favoriteDoctors = doctorProvider.doctors
            .where((d) => user.doctors.contains(d.id))
            .toList();
      }
    } catch (e) {
      debugPrint('❌ Error loading favorites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openRecipeDetails(Recipe recipe) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
      );

  void _openArticleDetails(Article article) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
      );

  void _openDoctorDetails(Doctor doctor) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DoctorDetailsPage(doctor: doctor)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: CustomScrollView(
            clipBehavior: Clip.none,
            slivers: [
              // 🔹 Header and Category Filter
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTopBarText(
                      title: 'Mes favoris',
                      onBack: () => Navigator.of(context).pop(),
                      topMargin: 30,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          return FilterChipBox(
                            label: category,
                            selected: _selectedCategory == category,
                            onTap: () => setState(() {
                              _selectedCategory = category;
                            }),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // 🔹 Loading shimmer
              if (_isLoading) ..._buildShimmerLoader()
              // 🔹 Actual content
              else ..._buildContentSlivers(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Shimmer loader for each category
  List<Widget> _buildShimmerLoader() {
    switch (_selectedCategory) {
      case 'Recettes':
        return [
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, __) => Shimmer.fromColors(
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
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ];

      case 'Articles':
      case 'Médecins':
        return [
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverList.builder(
              itemCount: 6,
              itemBuilder: (_, __) => Padding(
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
              ),
            ),
          ),
        ];
      default:
        return [];
    }
  }

  // 🔹 Build category-specific slivers
  List<Widget> _buildContentSlivers() {
    switch (_selectedCategory) {
   case 'Recettes':
  if (_favoriteRecipes.isEmpty) {
    return [_buildEmptySliver('Aucune recette favorite')];
  }
  return [
    SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final recipe = _favoriteRecipes[index];
            return SizedBox(
              height: 120, // Force height like RecipeRow
              child: AppRecipeBox(
                title: recipe.title,
                imageUrl: recipe.imageUrl,
                rating: recipe.rating,
                onTap: () => _openRecipeDetails(recipe),
              ),
            );
          },
          childCount: _favoriteRecipes.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 120 / 120, // Match the SizedBox height
        ),
      ),
    ),
  ];

      case 'Articles':
        if (_favoriteArticles.isEmpty) {
          return [_buildEmptySliver('Aucun article favori')];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverList.builder(
              itemCount: _favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = _favoriteArticles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: AppArticleBox(
                    title: article.title,
                    imageUrl: article.imageUrl.isNotEmpty
                        ? article.imageUrl.first
                        : '',
                    category: article.category,
                    timeAgo: _getTimeAgo(article.createdAt),
                    onTap: () => _openArticleDetails(article),
                  ),
                );
              },
            ),
          ),
        ];

   case 'Médecins':
  if (_favoriteDoctors.isEmpty) {
    return [_buildEmptySliver('Aucun médecin favori')];
  }
  return [
    SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final doctor = _favoriteDoctors[index];
            return GestureDetector(
              onTap: () => _openDoctorDetails(doctor),
              child: SizedBox(
               
                child: DoctorCard(
                  doctorName: doctor.name,
                  specialty: doctor.specialty,
                  rating: doctor.rating,
                  city: doctor.city,
                  imageUrl: doctor.imageUrl,
                ),
              ),
            );
          },
          childCount: _favoriteDoctors.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,       // 2 doctors per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 120 / 120, // Match SizedBox height
        ),
      ),
    ),
  ];

      default:
        return [_buildEmptySliver('Aucun favori trouvé')];
    }
  }

  // 🔹 Empty state inside Sliver
  Widget _buildEmptySliver(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border,
                size: 48, color: AppColors.lightPremier),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.inter14Med
                  .copyWith(color: AppColors.lightPremier),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
    return 'il y a ${diff.inDays} j';
  }
}
