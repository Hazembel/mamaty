// lib/widgets/app_top_bar_text.dart
import 'package:flutter/material.dart';
import 'app_back_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppTopBarText extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final double topMargin;
  final bool showBack;

  const AppTopBarText({
    super.key,
    required this.title,
    this.onBack,
    this.topMargin = 30,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔙 Back button on LEFT (like AppTopBar)
          if (showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(onTap: onBack),
            )
          else
            const SizedBox(width: 48), // keeps layout balanced

          // 🟡 Title centered
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.inter16Bold.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
