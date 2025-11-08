import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../icons/app_icons.dart';

class AppRecipeBox extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final VoidCallback onTap;

  const AppRecipeBox({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// 🖼 Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),

              /// 🌈 Gradient overlay (for better contrast)
              Container(
              decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        AppColors.premier.withValues(alpha: 0.95), // bottom color
        Colors.transparent,                  // top color
      ],
    ),
  ),
              ),

              /// ⭐ Rating pill (top-right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  height: 16,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.08),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcons.svg(
                        AppIcons.star,
                        size: 10,
                        color: AppColors.premier,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: AppTextStyles.inter8Med.copyWith(
                          color: AppColors.black,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 📖 Title (bottom-left)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    title,
                    style: AppTextStyles.inter12Med.copyWith(
                      color: Colors.white,
                  
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
