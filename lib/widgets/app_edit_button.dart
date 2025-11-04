import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppEditButton extends StatefulWidget {
  final VoidCallback? onTap; // optional custom action

  const AppEditButton({super.key, this.onTap});

  @override
  State<AppEditButton> createState() => _AppEditButtonState();
}

class _AppEditButtonState extends State<AppEditButton> {
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorders.all,
            boxShadow: [AppColors.defaultShadow],
          ),
          alignment: Alignment.center,
          child: AppIcons.svg(AppIcons.edit, size: 20, color: AppColors.premier),
        ),
      ),
    );
  }
}
