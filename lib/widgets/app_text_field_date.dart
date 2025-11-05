// lib/widgets/app_text_field_date.dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';
import 'package:intl/intl.dart'; // for formatting date

class AppTextFieldDate extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? errorText;

  const AppTextFieldDate({
    super.key,
    this.labelText = 'Quelle est votre date de naissance ?',
    this.controller,
    this.errorText,
  });

  @override
  State<AppTextFieldDate> createState() => _AppTextFieldDateState();
}

class _AppTextFieldDateState extends State<AppTextFieldDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2025),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
              setState(() {
                widget.controller?.text = formattedDate;
              });
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: widget.controller,
              style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
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
                    color: widget.errorText != null ? Colors.red : AppColors.premier,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppBorders.all,
                  borderSide: BorderSide(
                    color: widget.errorText != null ? Colors.red : AppColors.premier,
                    width: 1.5,
                  ),
                ),
                // 👇 Suffix icon (datepicker)
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AppIcons.svg(
                    AppIcons.datepicker, // your date icon from app_icons.dart
                    size: 22,
                    color: AppColors.black,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 24),
              ),
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
