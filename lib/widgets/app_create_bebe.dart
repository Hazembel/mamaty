import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../icons/app_icons.dart';

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
        height: size, // square box now
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppColors.defaultShadow],
        ),
        alignment: Alignment.center, // centers the icon directly
        child: AppIcons.svg(
          AppIcons.union,
          size: 40,
          color: AppColors.premier,
        ),
      ),
    );
  }
}
