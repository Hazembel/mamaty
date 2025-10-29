import 'package:flutter/material.dart';
import 'app_back_button.dart';
import 'app_logout_button.dart'; // <-- add this
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppTopBar extends StatelessWidget {
  final double topMargin;
  final VoidCallback? onBack;
  final VoidCallback? onLogout; // ✅ new
  final int? currentStep;
  final int? totalSteps;
  final bool showBack;
  final bool showLogout; // ✅ new flag

  const AppTopBar({
    super.key,
    this.topMargin = 30,
    this.onBack,
    this.onLogout,
    this.currentStep,
    this.totalSteps,
    this.showBack = true,
    this.showLogout = false, // ✅ default false
  });

  bool get showStepIndicator => currentStep != null && totalSteps != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showLogout)
            AppLogoutButton(onTap: onLogout)
          else if (showBack)
            AppBackButton(onTap: onBack)
          else
            const SizedBox(width: 48),

          if (showStepIndicator)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [AppColors.defaultShadow],
              ),
              child: Text(
                '$currentStep sur $totalSteps',
                style: AppTextStyles.inter14Med.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
