import 'package:flutter/material.dart';
import 'app_back_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
class AppTopBar extends StatelessWidget {
  final double topMargin;
  final VoidCallback? onBack;
  final int? currentStep; // ✅ optional
  final int? totalSteps;  // ✅ optional

  const AppTopBar({
    super.key,
    this.topMargin = 30,
    this.onBack,
    this.currentStep,
    this.totalSteps,
  });

  bool get showStepIndicator =>
      currentStep != null && totalSteps != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBackButton(onTap: onBack),
          if (showStepIndicator)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50), // ✅ round shape
                boxShadow: [AppColors.defaultShadow], // ✅ shadow
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
