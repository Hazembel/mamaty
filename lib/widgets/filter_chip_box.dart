import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// 🔹 Reusable filter chip box
/// Works for both text and rating filters
class FilterChipBox extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isRating; // whether to show a star icon

  const FilterChipBox({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.premier : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lightPremier , width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRating)
              Icon(
                Icons.star,
                size: 16,
                color: selected ? Colors.white : AppColors.premier,
              ),
            if (isRating) const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.inter14semiMed.copyWith(
                color: selected ? Colors.white : AppColors.premier,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
