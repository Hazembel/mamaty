import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';
import 'package:flutter/services.dart'; // 👈 needed for input formatters

class AppTextFieldPassword extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? errorText;

  const AppTextFieldPassword({
    super.key,
    required this.labelText,
    this.controller,
    this.errorText,
  });

  @override
  State<AppTextFieldPassword> createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool _obscureText = true; // starts hidden

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          obscureText: _obscureText, // hides or shows text
          style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            labelText: widget.labelText,
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
                color: widget.errorText != null
                    ? Colors.red
                    : AppColors.premier,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorders.all,
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? Colors.red
                    : AppColors.premier,
                width: 1.5,
              ),
            ),
            // 👇 Suffix icon (eye) for show/hide password
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: AppIcons.svg(
                  _obscureText ? AppIcons.showPassword : AppIcons.hidePassword,
                  size: 22,
                  color: AppColors.black,
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 24,
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.inter12Reg.copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
