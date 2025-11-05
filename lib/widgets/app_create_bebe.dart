import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../icons/app_icons.dart';

typedef OnCreateCallback = void Function();

class AppCreateBebe extends StatelessWidget {
  final OnCreateCallback? onTap;
  final double size;
  final double? iconSize;

  const AppCreateBebe({
    super.key,
    this.onTap,
    required this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size, // square box now
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.defaultShadow],
        ),
        alignment: Alignment.center, // centers the icon directly
        child: AppIcons.svg(
          AppIcons.union,
          size:
              iconSize ??
              (size * 0.3), // Make icon size relative to container size
          color: AppColors.premier,
        ),
      ),
    );
  }
}
