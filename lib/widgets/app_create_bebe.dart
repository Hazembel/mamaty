import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

typedef OnCreateCallback = void Function();

class AppCreateBebe extends StatelessWidget {
  final OnCreateCallback? onTap;
  final double size;

  const AppCreateBebe({
    super.key,
    this.onTap,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size + 40, // extra space for text
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.defaultShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                color: AppColors.premier,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajouter un enfant',
              style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}
