import 'package:flutter/material.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

enum ButtonSize { sm, md, lg }

class AppButton extends StatefulWidget {
  final String title;
  final ButtonSize size;
  final bool fullWidth;
  final VoidCallback? onPressed;
  final bool loading;

  const AppButton({
    super.key,
    required this.title,
    this.size = ButtonSize.md,
    this.fullWidth = true,
    this.onPressed,
    this.loading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  EdgeInsets get padding {
    switch (widget.size) {
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(vertical: 12, horizontal: 30);
      case ButtonSize.md:
        return const EdgeInsets.symmetric(vertical: 14, horizontal: 20);
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(vertical: 19, horizontal: 20);
    }
  } 

  double get fontSize {
    switch (widget.size) {
      case ButtonSize.sm:
        return 14;
      case ButtonSize.md:
        return 16;
      case ButtonSize.lg:
        return 18;
    }
  }

  void _onTapDown(_) => setState(() => _scale = 0.99);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.loading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.premier,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: AppBorders.all),
     
            elevation: 4,
          ),
          child: Listener(
            // Listener detects pointer down/up faster than GestureDetector
            onPointerDown: _onTapDown,
            onPointerUp: _onTapUp,

            onPointerCancel: (_) => _onTapCancel(),
            child: Text(
              widget.loading ? 'Loading...' : widget.title,
              style: AppTextStyles.inter16SemiBold.copyWith(
                fontSize: fontSize,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
