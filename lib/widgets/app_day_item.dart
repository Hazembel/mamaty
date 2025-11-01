import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

// Replace these with your app theme colors and text styles

class DayItem extends StatelessWidget {
  final String day;
  final String number;
  final bool isSelected;
  final VoidCallback onTap;

  const DayItem({
    super.key,
    required this.day,
    required this.number,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.premier : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightPremier, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: isSelected
                  ? AppTextStyles.inter14Med.copyWith(color: Colors.white)
                  : AppTextStyles.inter14Med.copyWith(color: AppColors.lightPremier),
            ),
            const SizedBox(height: 2),
            Text(
              number,
              style: isSelected
                  ? AppTextStyles.inter16SemiBold.copyWith(color: Colors.white)
                  : AppTextStyles.inter16SemiBold.copyWith(
                      color: AppColors.lightPremier,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
