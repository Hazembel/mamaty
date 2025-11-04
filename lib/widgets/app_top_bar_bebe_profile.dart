import 'package:flutter/material.dart';
import 'app_logout_button.dart';
 
import '../widgets/app_edit_button.dart';

class AppProfileBebe extends StatelessWidget {
  final double topMargin;
  final VoidCallback? onLogout;
  final VoidCallback? onEdit;

  const AppProfileBebe({
    super.key,
    this.topMargin = 30,
    this.onLogout,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Logout button
          AppLogoutButton(onTap: onLogout),

          // Right: Edit button
          AppEditButton(onTap: onEdit),
        ],
      ),
    );
  }
}
