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
  final String? loadingText;

  // 🎨 Optional color overrides (safe defaults)
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.title,
    this.size = ButtonSize.md,
    this.fullWidth = true,
    this.onPressed,
    this.loading = false,
    this.loadingText,
    this.backgroundColor, // new
    this.textColor, // new
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
        return 15;
      case ButtonSize.lg:
        return 16;
    }
  }

  void _onTapDown(_) => setState(() => _scale = 0.99);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final String displayText =
        widget.loading ? (widget.loadingText ?? 'Loading...') : widget.title;

    // 🧩 Default colors (safe for all pages)
    final Color buttonColor = widget.backgroundColor ?? AppColors.premier;
    final Color textColor = widget.textColor ?? AppColors.white;

    return SizedBox(
      width: widget.fullWidth ? double.infinity : 176,
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.loading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: AppBorders.all),
            elevation: 4,
          ),
          child: Listener(
            onPointerDown: _onTapDown,
            onPointerUp: _onTapUp,
            onPointerCancel: (_) => _onTapCancel(),
            child: Text(
              displayText,
              style: AppTextStyles.inter16medium.copyWith(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
