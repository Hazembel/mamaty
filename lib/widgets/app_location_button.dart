import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppLocationButton extends StatefulWidget {
  final VoidCallback? onTap; // optional custom action

  const AppLocationButton({super.key, this.onTap});

  @override
  State<AppLocationButton> createState() => _AppLocationButtonState();
}

class _AppLocationButtonState extends State<AppLocationButton> {
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorders.all,
            boxShadow: [AppColors.defaultShadow],
          ),
          alignment: Alignment.center,
          child: AppIcons.svg(AppIcons.locationborder, size: 24  ),
        ),
      ),
    );
  }
}
