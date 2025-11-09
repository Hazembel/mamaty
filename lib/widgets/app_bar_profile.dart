import 'package:flutter/material.dart';
import 'app_back_button.dart';
import 'app_faq_button.dart';
import 'app_save_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppProfileBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onFaq;
  final bool? isSaved; // current saved state
  final VoidCallback? onSaveToggle;
  final double topMargin;

  const AppProfileBar({
    super.key,
    this.onBack,
    this.onFaq,
    this.isSaved,
    this.onSaveToggle,
    this.topMargin = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Back Button
          AppBackButton(onTap: onBack
          
          
          ),

          // Middle: Title
          Expanded(
            child: Center(
              child: Text(
                'Modifier le profil',
                style: AppTextStyles.inter16Bold.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // Right: FAQ + Save buttons
          Row(
            children: [
              if (onFaq != null)
                AppFaqButton(onTap: onFaq),
              const SizedBox(width: 10),
              if (isSaved != null && onSaveToggle != null)
                AppSaveButton(
                  isSaved: isSaved!,
                  onToggle: onSaveToggle!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
