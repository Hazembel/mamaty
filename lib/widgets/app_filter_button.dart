import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppFilterButton extends StatefulWidget {
  final VoidCallback? onTap; // optional custom action

  const AppFilterButton({super.key, this.onTap});

  @override
  State<AppFilterButton> createState() => _AppFilterButtonState();
}

class _AppFilterButtonState extends State<AppFilterButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95), // pressed down
      onTapUp: (_) => setState(() => _scale = 1.0), // release
      onTapCancel: () => setState(() => _scale = 1.0), // canceled
      onTap: widget.onTap ?? () => Navigator.of(context).maybePop(),
      child: AnimatedScale(
        scale: _scale,
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
          child: AppIcons.svg(AppIcons.filter, size: 20, color: AppColors.black),
        ),
      ),
    );
  }
}
