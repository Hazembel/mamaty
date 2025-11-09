import 'package:flutter/material.dart';
import 'app_back_button.dart';
import 'app_contact_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppFaqBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onContact;
  final double topMargin;

  const AppFaqBar({
    super.key,
    this.onBack,
    this.onContact,
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
          AppBackButton(onTap: onBack),

          // Middle: Title
          Expanded(
            child: Center(
              child: Text(
                'FAQ',
                style: AppTextStyles.inter16Bold.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // Right: Contact button
          AppContactButton(onTap: onContact),
        ],
      ),
    );
  }
}
