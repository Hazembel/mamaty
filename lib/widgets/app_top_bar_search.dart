import 'package:flutter/material.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/app_filter_button.dart';
import '../widgets/app_ingredient_button.dart';

class AppSearchInput extends StatelessWidget {
  final String searchText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onIngredientTap;
  final ValueChanged<String>? onChanged;
  final bool showIngredientButton; // ✅ New flag

  const AppSearchInput({
    super.key,
    required this.searchText,
    this.onSearchTap,
    this.onFilterTap,
    this.onIngredientTap,
    this.onChanged,
    this.showIngredientButton = false, // hidden by default
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

        // Ingredient filter button (conditionally shown)
        if (showIngredientButton)
          AppFilterIngredientButton(
            onTap: onIngredientTap,
          ),

        if (showIngredientButton) const SizedBox(width: 10),

        // Main filter button
        AppFilterButton(onTap: onFilterTap),
      ],
    );
  }
}
