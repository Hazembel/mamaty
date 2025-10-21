import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Use your app-wide colors

/// A widget to display an avatar image with a rounded container and shadow
class AvatarTile extends StatelessWidget {
  final String imagePath;
  final double size;

  const AvatarTile({
    super.key,
    required this.imagePath,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [AppColors.defaultShadow], // from theme/colors.dart
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
