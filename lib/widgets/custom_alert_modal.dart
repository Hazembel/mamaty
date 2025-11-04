import 'package:flutter/material.dart';
import '../icons/app_icons.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../../widgets/app_button.dart';

class CustomAlertModal extends StatefulWidget {
  final String title;
  final String message;
  final String? primaryText;
  final String? secondaryText;
  final Future<void> Function()? onPrimary;
  final VoidCallback? onSecondary;
  final bool showDangerIcon;

  const CustomAlertModal({
    super.key,
    required this.title,
    required this.message,
    this.primaryText = 'Consulter',
    this.secondaryText = 'Modifier',
    this.onPrimary,
    this.onSecondary,
    this.showDangerIcon = true,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryText,
    String? secondaryText,
    Future<void> Function()? onPrimary,
    VoidCallback? onSecondary,
    bool showDangerIcon = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: CustomAlertModal(
          title: title,
          message: message,
          primaryText: primaryText ?? 'Consulter',
          secondaryText: secondaryText ?? 'Modifier',
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          showDangerIcon: showDangerIcon,
        ),
      ),
    );
  }

  @override
  State<CustomAlertModal> createState() => _CustomAlertModalState();
}

class _CustomAlertModalState extends State<CustomAlertModal> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              if (widget.showDangerIcon) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: AppIcons.svg(AppIcons.dangericon, size: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter16SemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      title: widget.secondaryText ?? '',
                      backgroundColor: AppColors.lightPremier,
                      textColor: AppColors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (widget.onSecondary != null) widget.onSecondary!();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      title: widget.primaryText ?? '',
                      backgroundColor: AppColors.premier,
                      textColor: Colors.white,
                      loading: _isLoading,
                      onPressed: () async {
                        if (widget.onPrimary == null) return;
                        setState(() => _isLoading = true);
                        try {
                          await widget.onPrimary!();
                          if (mounted) Navigator.of(context).pop();
                        } catch (e) {
                          debugPrint('❌ Modal primary action failed: $e');
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
