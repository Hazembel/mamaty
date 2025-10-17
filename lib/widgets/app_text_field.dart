// lib/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/border_radius.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? errorText; // <-- new

  const AppTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: AppTextStyles.inter14Med.copyWith(
              color: AppColors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorders.all,
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : AppColors.premier,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorders.all,
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : AppColors.premier,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.inter12Reg.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
