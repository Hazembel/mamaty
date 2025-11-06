import 'dart:convert';
import '../api/api_helper.dart';
import '../models/recipe.dart';
import 'package:flutter/foundation.dart';

class RecipeService {
  /// ✅ Get recipes with optional filters
  static Future<List<Recipe>> getRecipes({
    String? city,
    String? category,
    String? ingredient,
    double? rating, // min rating
  }) async {
    try {
      final queryParams = <String, String>{};
      if (city != null) queryParams['city'] = city;
      if (category != null) queryParams['category'] = category;
      if (ingredient != null) queryParams['ingredient'] = ingredient;
      if (rating != null) queryParams['rating'] = rating.toString();

      final queryString = queryParams.entries.isNotEmpty
          ? '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')
          : '';

      final response = await ApiHelper.get('/recipes$queryString');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final recipes = data.map((json) => Recipe.fromJson(json)).toList();

        debugPrint('✅ Fetched ${recipes.length} recipes');
        return recipes;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error loading recipes: $e');
      throw Exception('Failed to load recipes: $e');
    }
  }

  /// ✅ Create new recipe
  static Future<Recipe> createRecipe(Recipe recipe) async {
    final response = await ApiHelper.post('/recipes', recipe.toJson());
    if (response.statusCode == 201) {
      return Recipe.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create recipe: ${response.statusCode}');
    }
  }

  /// ✅ Update recipe by ID
  static Future<Recipe> updateRecipe(String recipeId, Map<String, dynamic> updates) async {
    final response = await ApiHelper.put('/recipes/$recipeId', updates);
    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update recipe: ${response.statusCode}');
    }
  }

  /// ✅ Delete recipe by ID
  static Future<void> deleteRecipe(String recipeId) async {
    final response = await ApiHelper.delete('/recipes/$recipeId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete recipe: ${response.statusCode}');
    }
    debugPrint('🗑️ Deleted recipe $recipeId');
  }

  /// ✅ Vote (like/dislike) a recipe
  static Future<Recipe> voteRecipe({
    required String recipeId,
    required String userId,
    required String type, // 'like' or 'dislike'
  }) async {
    final response = await ApiHelper.post('/recipes/$recipeId/vote', {
      'userId': userId,
      'type': type,
    });

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to vote recipe: ${response.statusCode}');
    }
  }

/// ✅ Toggle favorite status for a recipe
static Future<bool> toggleFavoriteRecipe({
  required String recipeId,
}) async {
  final response = await ApiHelper.post('/users/favorite-recipe/$recipeId', {});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['isFavorite'] ?? false;
  } else {
    throw Exception('Failed to toggle favorite: ${response.statusCode}');
  }
}


}
