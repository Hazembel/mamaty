import 'package:flutter/material.dart';
import 'app_back_button.dart';

class AppTopBar extends StatelessWidget {
  final double topMargin;
  final VoidCallback? onBack;

  const AppTopBar({
    super.key,
    this.topMargin = 30, // default top margin
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Row(
        children: [
          AppBackButton(
            onTap: onBack, // default pops if null
          ),
          // You can add title or other icons here later
        ],
      ),
    );
  }
}
