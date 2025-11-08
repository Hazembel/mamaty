import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppArticleBox extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String category;
  final String timeAgo;
  final VoidCallback? onTap;

  const AppArticleBox({
    super.key,
    required this.title,
    required this.imageUrl,
    this.category = '',
    this.timeAgo = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth > 0 ? constraints.maxWidth : 332.0;
          final imageWidth = 139.0;
          final imageHeight = 140.0;
          final spacing = 12.0;
          final borderRadius = 16.0;

          return Container(
            width: width,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Article Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  child: Image.network(
                    imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: imageWidth,
                      height: imageHeight,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),

                SizedBox(width: spacing),

                // 🔹 Text Column
                Expanded(
                  child: SizedBox(
                    height: imageHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 0),
                        // Title
                        Text(
                          title,
                          style: AppTextStyles.inter12Med.copyWith(
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),
                        // Category
                        Text(
                          category,
                          style: AppTextStyles.inter12Med.copyWith(
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Time ago
                        Text(
                          timeAgo,
                          style: AppTextStyles.inter12Med.copyWith(
                            color: AppColors.premier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
