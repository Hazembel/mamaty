import 'package:flutter/material.dart';

import '../theme/text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/filter_chip_box.dart';
import '../widgets/app_search_bar.dart';
import './ingredient_assets.dart';

class IngredientFilterModalResult {
  final List<String> ingredients; // ✅ multiple ingredients

  IngredientFilterModalResult({required this.ingredients});
}

class IngredientFilterModal extends StatefulWidget {
  final List<String> allIngredients;

  const IngredientFilterModal({super.key, required this.allIngredients});

  static Future<IngredientFilterModalResult?> show(
    BuildContext context, {
    required List<String> allIngredients,
  }) {
    return showModalBottomSheet<IngredientFilterModalResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha:0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: IngredientFilterModal(allIngredients: allIngredients),
        );
      },
    );
  }

  @override
  State<IngredientFilterModal> createState() => _IngredientFilterModalState();
}

class _IngredientFilterModalState extends State<IngredientFilterModal> {
  List<String> selectedIngredients = []; // ✅ support multiple
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredIngredients = widget.allIngredients
        .where((i) => i.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Center(
              child: Text(
                'Filtrer par ingrédients',
                style: AppTextStyles.inter16SemiBold.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // 🔍 Search bar
            AppSearchBar(
              hintText: 'Rechercher un ingrédient ...',
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 12),

            // 🥕 Ingredient chips
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: filteredIngredients.map((ingredient) {
                    final isSelected = selectedIngredients.contains(ingredient);

                    // Optional: emoji mapping
                final emoji = IngredientAssets.emoji[ingredient] ?? '';
final displayLabel = '$emoji $ingredient';

                    return FilterChipBox(
                      label: displayLabel,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIngredients.remove(ingredient);
                          } else {
                            selectedIngredients.add(ingredient);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: AppButton(
                title: 'Filtrer',
                fullWidth: false,
                size: ButtonSize.md,
                onPressed: () {
                  Navigator.of(context).pop(
                    IngredientFilterModalResult(
                      ingredients: selectedIngredients, // ✅ multiple
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
