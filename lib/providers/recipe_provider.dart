import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  /// Load recipes with optional filters
  Future<void> loadRecipes({
    String? city,
    String? category,
    String? ingredient,
    double? rating, // min rating
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedRecipes = await RecipeService.getRecipes(
        city: city,
        category: category,
        ingredient: ingredient,
        rating: rating, // updated param
      );

      _recipes
        ..clear()
        ..addAll(fetchedRecipes);

      debugPrint('✅ Loaded ${_recipes.length} recipes');
    } catch (e) {
      debugPrint('❌ Failed to load recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add recipe locally
  void addRecipe(Recipe recipe) {
    if (!_recipes.any((r) => r.id == recipe.id)) {
      _recipes.add(recipe);
      notifyListeners();
    }
  }

  /// Update existing recipe locally
  void updateRecipe(Recipe updatedRecipe) {
    final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  /// Remove recipe locally
  void removeRecipe(String recipeId) {
    _recipes.removeWhere((r) => r.id == recipeId);
    notifyListeners();
  }

  /// Vote (like/dislike) a recipe
  Future<void> voteRecipe(Recipe recipe, String userId, String type) async {
    try {
      final updatedRecipe = await RecipeService.voteRecipe(
        recipeId: recipe.id!,
        userId: userId,
        type: type,
      );

      // Update local recipe
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index].likes = updatedRecipe.likes;
        _recipes[index].dislikes = updatedRecipe.dislikes;
        _recipes[index].rating = updatedRecipe.rating;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Failed to vote recipe: $e');
    }
  }
}
