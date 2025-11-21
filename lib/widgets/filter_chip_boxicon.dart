import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// 🔹 Reusable filter chip box
/// Works for text, rating, or ingredient icons
class FilterChipBoxicon extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isRating;      // show star
  final IconData? icon;     // show generic icon (emoji/ingredient)

  const FilterChipBoxicon({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isRating = false,
    this.icon,              // optional icon
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
            if (icon != null)
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppColors.premier,
              ),
            if (icon != null) const SizedBox(width: 6),
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
