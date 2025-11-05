import 'package:flutter/material.dart';
import 'app_back_button.dart';
import 'app_share_button.dart';
import 'app_save_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppTopBarText extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final bool showBack;
  final bool showShare;
  final bool showSave;
  final bool showTitle;
  
  // ✅ New: state for save button
  final bool? isSaved;
  final VoidCallback? onToggleSave;

  final double topMargin;

  const AppTopBarText({
    super.key,
    this.title,
    this.onBack,
    this.onShare,
    this.showBack = true,
    this.showShare = false,
    this.showSave = false,
    this.showTitle = true,
    this.topMargin = 30,
    this.isSaved,
    this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔙 Back button (left)
          if (showBack)
            AppBackButton(onTap: onBack)
          else
            const SizedBox(width: 40),

          // 🟡 Optional centered title
          if (showTitle && title != null)
            Expanded(
              child: Center(
                child: Text(
                  title!,
                  style: AppTextStyles.inter16Bold.copyWith(
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            const Spacer(),

          // 📤 Share + 💾 Save buttons (right)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showShare)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AppShareButton(onTap: onShare),
                ),
              if (showSave && isSaved != null && onToggleSave != null)
                AppSaveButton(
                  isSaved: isSaved!,
                  onToggle: onToggleSave!,
                ),
              if (!showShare && !showSave)
                const SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }
}
