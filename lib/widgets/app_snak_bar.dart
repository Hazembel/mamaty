import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppSnackBar {
  /// Show a custom styled SnackBar
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.premier,
    int durationSeconds = 2,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }
}
