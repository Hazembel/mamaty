import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/app_recipe_box.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../widgets/filter_modal.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../providers/recipe_provider.dart';
import '../models/recipe.dart';
import '../widgets/filter_ingredients.dart';
import '../pages/recipe_detail_page.dart'; 
 
class RecipesPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;

  const RecipesPage({
    super.key,
    this.title = 'Recettes',
    this.searchPlaceholder = 'Rechercher une recette',
    this.onBack,
  });

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load recipes after first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecipes();
    });
  }
  // ✅ Open detail page
  void _openRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(recipe: recipe),
      ),
    );
  }
  Future<void> _loadRecipes({
    String? city,
    String? category,
    String? ingredient,
    double? minRating,
  }) async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<RecipeProvider>();
      await provider.loadRecipes(
        city: city,
        category: category,
        ingredient: ingredient,
        rating: minRating,
      );

      setState(() {
        _allRecipes = provider.recipes;
        _filteredRecipes = provider.recipes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading recipes: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      _filteredRecipes = _allRecipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// 🔧 Filter modal for city/category/rating
  Future<void> _openFilterModal() async {
    try {
      final allCities = _allRecipes
          .map((r) => r.city)
          .whereType<String>()
          .toSet()
          .toList();
      final allCategories = _allRecipes
          .map((r) => r.category)
          .whereType<String>()
          .toSet()
          .toList();

      final result = await FilterModal.show(
        context,
        allcity: allCities,
        allSpecialties: allCategories,
      );

      if (result != null) {
        List<Recipe> filtered = _allRecipes;

        if (result.city.isNotEmpty) {
          filtered =
              filtered.where((r) => r.city == result.city.first).toList();
        }
        if (result.specialties.isNotEmpty) {
          filtered =
              filtered.where((r) => r.category == result.specialties.first).toList();
        }
        if (result.rating > 0) {
          filtered =
              filtered.where((r) => r.rating >= result.rating).toList();
        }

        setState(() => _filteredRecipes = filtered);
      }
    } catch (e) {
      debugPrint('❌ Failed to open filters: $e');
      if (!mounted) return;
     
    }
  }

  /// 🔧 Ingredient filter modal
Future<void> _openIngredientFilter() async {
  final allIngredients = _allRecipes
      .expand((r) => r.ingredients.map((i) => i.name))
      .toSet()
      .toList();

  final result = await IngredientFilterModal.show(
    context,
    allIngredients: allIngredients,
  );

  setState(() {
    if (result == null || result.ingredient.isEmpty) {
      // No ingredient selected → show all recipes
      _filteredRecipes = _allRecipes;
    } else {
      _filteredRecipes = _allRecipes
          .where((r) => r.ingredients.any((i) => i.name == result.ingredient))
          .toList();
    }
  });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTopBarText(
                      title: widget.title,
                      onBack: widget.onBack ??
                          () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                          },
                    ),
                    const SizedBox(height: 15),
                    AppSearchInput(
                      searchText: widget.searchPlaceholder,
                      onChanged: _filterRecipes,
                      onFilterTap: _openFilterModal,
                      onIngredientTap: _openIngredientFilter, // ingredient filter
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // 🔹 Recipes Grid or shimmer
              _isLoading
                  ? SliverPadding(
                      padding: const EdgeInsets.only(top: 10),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 150 / 170,
                        ),
                        itemCount: 6,
                        itemBuilder: (_, __) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : _filteredRecipes.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: const Center(
                            child: Text('Aucune recette trouvée.'),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.only(bottom: 20),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              childAspectRatio: 150 / 150,
                            ),
                            itemCount: _filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = _filteredRecipes[index];
                              return AppRecipeBox(
                                title: recipe.title,
                                imageUrl: recipe.imageUrl,
                                rating: recipe.rating,
                               onTap: () => _openRecipeDetails(recipe),
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
}
