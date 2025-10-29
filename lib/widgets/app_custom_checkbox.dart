import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../icons/app_icons.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import'../../theme/border_radius.dart';

class SvgCheckboxRow extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SvgCheckboxRow({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SvgCheckboxRow> createState() => _SvgCheckboxRowState();
}

class _SvgCheckboxRowState extends State<SvgCheckboxRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.premier : Colors.transparent,
          borderRadius: BorderRadius.circular(AppBorders.defaultRadius),
          border: widget.isSelected
              ? Border.all(color: AppColors.premier)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.inter16medium.copyWith(
                color: widget.isSelected ? Colors.white : Colors.black,
              ),
            ),
            SvgPicture.string(
              widget.isSelected
                  ? AppIcons.checkboxchecked
                  : AppIcons.checkboxempty,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
