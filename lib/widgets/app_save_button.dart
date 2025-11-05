import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppSaveButton extends StatelessWidget {
  final bool isSaved; // current saved state from provider
  final VoidCallback onToggle;

  const AppSaveButton({
    super.key,
    required this.isSaved,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;

    return GestureDetector(
      onTapDown: (_) => scale = 0.95,
      onTapUp: (_) => scale = 1.0,
      onTapCancel: () => scale = 1.0,
      onTap: onToggle,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorders.all,
            boxShadow: [AppColors.defaultShadow],
          ),
          alignment: Alignment.center,
          child: AppIcons.svg(
            isSaved ? AppIcons.saved : AppIcons.save,
            size: 22,
            color: isSaved ? AppColors.premier : AppColors.black,
          ),
        ),
      ),
    );
  }
}
