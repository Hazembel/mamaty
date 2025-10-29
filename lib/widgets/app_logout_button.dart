import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../icons/app_icons.dart'; // if you have a logout icon here

class AppLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AppLogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [AppColors.defaultShadow],
        ),
        child: Center(
          child: AppIcons.svg(AppIcons.logout, size: 24, color: AppColors.premier),
        ),
      ),
    );
  }
}
