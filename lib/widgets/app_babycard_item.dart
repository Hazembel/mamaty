import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';

class BabyDayCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const BabyDayCard({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            // Transparent black overlay
          // Transparent to premier color overlay
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
            // Text at bottom left
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: AppTextStyles.inter16SemiBold.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
