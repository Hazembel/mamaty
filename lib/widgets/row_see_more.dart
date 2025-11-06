import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppRowSeeMore extends StatefulWidget {
  final String title;
  final VoidCallback onSeeMore;

  const AppRowSeeMore({
    super.key,
    required this.title,
    required this.onSeeMore,
  });

  @override
  State<AppRowSeeMore> createState() => _AppRowSeeMoreState();
}

class _AppRowSeeMoreState extends State<AppRowSeeMore> {
  bool _isPressed = false;

  void _onTapDown(_) => setState(() => _isPressed = true);
  void _onTapUp(_) {
    setState(() => _isPressed = false);
    widget.onSeeMore();
  }

  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left title
          Text(
            widget.title,
            style: AppTextStyles.inter16SemiBold.copyWith(
              color: AppColors.black,
            ),
          ),

          // Right animated "Tout voir"
          GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              style: AppTextStyles.inter14Med.copyWith(
                color: AppColors.premier,
                fontWeight: _isPressed ? FontWeight.bold : FontWeight.w500,
              ),
              child: const Text('Tout voir'),
            ),
          ),
        ],
      ),
    );
  }
}
