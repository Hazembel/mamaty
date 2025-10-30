import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.inter14Med.copyWith(
          color: AppColors.lightPremier,
        ),

        // ✅ Fixed icon padding & size
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 6),
          child: SvgPicture.string(
            AppIcons.search,
            width: 18,
            height: 18,
          ),
        ),

        // ✅ Constraints to actually make width/height apply
        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: 34,
          maxHeight: 34,
        ),

        // ✅ Padding inside the input field
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

        filled: true,
        fillColor: AppColors.white,

        // ✅ Borders
        border: OutlineInputBorder(
          borderRadius: AppBorders.all,
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorders.all,
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorders.all,
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),

        isDense: true,
      ),

      // ✅ Text style
      style: AppTextStyles.inter14Med.copyWith(
        color: AppColors.premier,
      ),
    );
  }
}
