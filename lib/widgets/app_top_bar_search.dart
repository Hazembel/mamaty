import 'package:flutter/material.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_filter_button.dart';
import '../widgets/app_ingredient_button.dart';

class AppSearchInput extends StatelessWidget {
  final String searchText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onIngredientTap; // ✅ ingredient button callback
  final ValueChanged<String>? onChanged;

  const AppSearchInput({
    super.key,
    required this.searchText,
    this.onSearchTap,
    this.onFilterTap,
    this.onIngredientTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search bar expands to take remaining space
        Expanded(
          child: AppSearchBar(
            hintText: searchText,
            onChanged: onChanged,
          ),
        ),

        const SizedBox(width: 10),

        // Ingredient filter button
        AppFilterIngredientButton(
          onTap: onIngredientTap,
        ),

        const SizedBox(width: 10),

        // Main filter button
        AppFilterButton(onTap: onFilterTap),
      ],
    );
  }
}
