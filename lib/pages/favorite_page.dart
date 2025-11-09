import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/filter_chip_box.dart';
import '../widgets/app_bar_profile.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/dimensions.dart';
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
        // Load favorite recipes
        final recipeProvider = context.read<RecipeProvider>();
        await recipeProvider.loadRecipes();
        _favoriteRecipes = recipeProvider.recipes
            .where((recipe) => user.recipes.contains(recipe.id))
            .toList();

        // Load favorite articles
        final articleProvider = context.read<ArticleProvider>();
        await articleProvider.loadArticles();
        _favoriteArticles = articleProvider.articles
            .where((article) => user.articles.contains(article.id))
            .toList();

        // Load favorite doctors
        final doctorProvider = context.read<DoctorProvider>();
        await doctorProvider.loadDoctors();
        _favoriteDoctors = doctorProvider.doctors
            .where((doctor) => user.doctors.contains(doctor.id))
            .toList();
      }
    } catch (e) {
      debugPrint('❌ Error loading favorites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
    );
  }

  void _openArticleDetails(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(article: article),
      ),
    );
  }

  void _openDoctorDetails(Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetailsPage(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom app bar
          AppProfileBar(
            onBack: () => Navigator.of(context).pop(),
            topMargin: 40,
          ),

          // Title
          Padding(
            padding: AppDimensions.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes favoris',
                  style: AppTextStyles.inter24Bold.copyWith(
                    color: AppColors.premier,
                  ),
                ),
                const SizedBox(height: 20),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories
                        .map(
                          (category) => FilterChipBox(
                            label: category,
                            selected: _selectedCategory == category,
                            onTap: () => setState(() {
                              _selectedCategory = category;
                            }),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),

          // Content based on selected filter
          Expanded(
            child: Padding(
              padding: AppDimensions.pagePadding,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_selectedCategory) {
      case 'Recettes':
        if (_favoriteRecipes.isEmpty) {
          return _buildEmptyState('Aucune recette favorite');
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: _favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = _favoriteRecipes[index];
            return _buildRecipeCard(recipe);
          },
        );

      case 'Articles':
        if (_favoriteArticles.isEmpty) {
          return _buildEmptyState('Aucun article favori');
        }
        return ListView.builder(
          itemCount: _favoriteArticles.length,
          itemBuilder: (context, index) {
            final article = _favoriteArticles[index];
            return _buildArticleCard(article);
          },
        );

      case 'Médecins':
        if (_favoriteDoctors.isEmpty) {
          return _buildEmptyState('Aucun médecin favori');
        }
        return ListView.builder(
          itemCount: _favoriteDoctors.length,
          itemBuilder: (context, index) {
            final doctor = _favoriteDoctors[index];
            return _buildDoctorCard(doctor);
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 48,
            color: AppColors.lightPremier,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.inter14Med.copyWith(
              color: AppColors.lightPremier,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return AppRecipeBox(
      title: recipe.title,
      imageUrl: recipe.imageUrl,
      rating: recipe.rating,
      onTap: () => _openRecipeDetails(recipe),
    );
  }

  Widget _buildArticleCard(Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AppArticleBox(
        title: article.title,
        imageUrl: article.imageUrl.isNotEmpty ? article.imageUrl.first : '',
        category: article.category,
        timeAgo: article.createdAt.toString(),
        onTap: () => _openArticleDetails(article),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return GestureDetector(
      onTap: () => _openDoctorDetails(doctor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: DoctorCard(
          doctorName: doctor.name,
          specialty: doctor.specialty,
          rating: doctor.rating,
          city: doctor.city,
          imageUrl: doctor.imageUrl,
        ),
      ),
    );
  }
}
