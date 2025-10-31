import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppSaveButton extends StatefulWidget {
  final VoidCallback? onSave;   // called when saved
  final VoidCallback? onUnsave; // called when unsaved
  final bool initialSaved;      // default state (optional)

  const AppSaveButton({
    super.key,
    this.onSave,
    this.onUnsave,
    this.initialSaved = false,
  });

  @override
  State<AppSaveButton> createState() => _AppSaveButtonState();
}

class _AppSaveButtonState extends State<AppSaveButton> {
  bool _isSaved = false;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialSaved;
  }

  void _toggleSaved() {
    setState(() => _isSaved = !_isSaved);

    if (_isSaved) {
      widget.onSave?.call();
    } else {
      widget.onUnsave?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: _toggleSaved,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white, // ✅ stays white always
            borderRadius: AppBorders.all,
            boxShadow: [AppColors.defaultShadow],
          ),
          alignment: Alignment.center,
          child: AppIcons.svg(
            _isSaved ? AppIcons.saved : AppIcons.save,
            size: 22,
            color: _isSaved
                ? AppColors.premier // ✅ heart turns premier when saved
                : AppColors.black,  // ❌ black when unsaved
          ),
        ),
      ),
    );
  }
}
