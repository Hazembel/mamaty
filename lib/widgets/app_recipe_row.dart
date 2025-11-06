import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/app_recipe_box.dart';
import '../pages/recipe_page.dart';
import '../pages/recipe_detail_page.dart'; 

class RecipeRow extends StatefulWidget {
  const RecipeRow({super.key});

  @override
  State<RecipeRow> createState() => _RecipeRowState();
}

class _RecipeRowState extends State<RecipeRow> {
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      await provider.loadRecipes(rating: 4.0); // Load top-rated recipes
    } catch (e) {
      debugPrint('❌ Error loading recipes: $e');
    }
  }

  void _openRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
builder: (_) => RecipeDetailPage(recipe: recipe),
      ),
    );
  }

  void _openAllRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RecipesPage(title: 'Toutes les recettes'),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final recipes = provider.recipes.take(10).toList();
    final isLoading = provider.isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + see more
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meilleures recettes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _openAllRecipes,
                child: const Text('Tout voir'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Recipe row
          if (isLoading)
            _buildSkeletonLoader()
          else if (recipes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Aucune recette trouvée.'),
            )
          else
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
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
    );
  }
}
