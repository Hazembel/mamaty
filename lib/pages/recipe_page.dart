import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../widgets/app_recipe_box.dart';

class RecipesPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;

  const RecipesPage({
    super.key,
    this.title = 'Meilleures recettes',
    this.searchPlaceholder = 'Rechercher une recette',
    this.onBack,
  });

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Map<String, dynamic>> _allRecipes = [];
  List<Map<String, dynamic>> _filteredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);

    // simulate a delay like API call
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyRecipes = [
      {
        'title': 'Purée de carottes',
        'image':
            'https://images.unsplash.com/photo-1589302168068-964664d93dc0?auto=format&fit=crop&w=800&q=60',
        'rating': 4.8
      },
      {
        'title': 'Compote de pommes maison',
        'image':
            'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?auto=format&fit=crop&w=800&q=60',
        'rating': 4.6
      },
      {
        'title': 'Soupe de potiron doux',
        'image':
            'https://images.unsplash.com/photo-1604908177339-3e56f1d1b45a?auto=format&fit=crop&w=800&q=60',
        'rating': 4.9
      },
      {
        'title': 'Purée de patate douce',
        'image':
            'https://images.unsplash.com/photo-1601050690597-0dbceabef7c8?auto=format&fit=crop&w=800&q=60',
        'rating': 4.7
      },
      {
        'title': 'Purée de petits pois',
        'image':
            'https://images.unsplash.com/photo-1601050690149-9c02f30d6b23?auto=format&fit=crop&w=800&q=60',
        'rating': 4.5
      },
    ];

    setState(() {
      _allRecipes = dummyRecipes;
      _filteredRecipes = dummyRecipes;
      _isLoading = false;
    });
  }

  void _filterRecipes(String query) {
    setState(() {
      _filteredRecipes = _allRecipes
          .where((recipe) =>
              recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
              AppTopBarText(
                title: widget.title,
                onBack: widget.onBack ??
                    () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
              ),
              const SizedBox(height: 15),

              // 🔍 Search bar
              AppSearchInput(
                searchText: widget.searchPlaceholder,
                onChanged: _filterRecipes,
              ),

              const SizedBox(height: 15),

              // 🍲 Recipes grid
              Expanded(
                child: _isLoading
                    ? _buildRecipeShimmer()
                    : _filteredRecipes.isEmpty
                        ? const Center(child: Text('Aucune recette trouvée.'))
                        : GridView.builder(
                            padding: EdgeInsets.zero,
                            clipBehavior: Clip.none,
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
                                title: recipe['title'],
                                imageUrl: recipe['image'],
                                rating: recipe['rating'],
                                onTap: () {
                                  // later you can open RecipeDetailsPage
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Ouvrir: ${recipe['title']}')),
                                  );
                                },
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

  /// 💫 Shimmer for recipes
  Widget _buildRecipeShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 10,
          childAspectRatio: 150 / 150,
        ),
        itemCount: 6,
        itemBuilder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}
