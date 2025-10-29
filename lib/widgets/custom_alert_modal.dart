import 'package:flutter/material.dart';
import '../icons/app_icons.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../../widgets/app_button.dart'; // ✅ import your button

class CustomAlertModal extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryText;
  final String? secondaryText;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final bool showDangerIcon;

  const CustomAlertModal({
    super.key,
    required this.title,
    required this.message,
    this.primaryText = 'Consulter',
    this.secondaryText = 'Modifier L\'maladie',
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
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    bool showDangerIcon = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
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

              if (showDangerIcon) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
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
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter16SemiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.inter14Med.copyWith(
                  color:  AppColors.black,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Buttons section
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      title: secondaryText ?? '',
                      size: ButtonSize.sm,
                      backgroundColor: AppColors.lightPremier,
                      textColor: AppColors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onSecondary != null) onSecondary!();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      title: primaryText ?? '',
                      size: ButtonSize.sm,
                      backgroundColor: AppColors.premier,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onPrimary != null) onPrimary!();
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
