import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';
import '../icons/app_icons.dart';
import '../theme/text_styles.dart';

class GenderSelector extends StatefulWidget {
  final ValueChanged<String> onGenderSelected;

  const GenderSelector({super.key, required this.onGenderSelected});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  // Use ValueNotifier to isolate state
  final ValueNotifier<String?> _selectedGender = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _selectedGender.dispose();
    super.dispose();
  }

  void _selectGender(String gender) {
    _selectedGender.value = gender;
    widget.onGenderSelected(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tu est',
          style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<String?>(
          valueListenable: _selectedGender,
          builder: (context, selectedGender, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GenderBox(
                  iconSvg: AppIcons.femaleicon,
                  isSelected: selectedGender == 'female',
                  onTap: () => _selectGender('female'),
                ),
                const SizedBox(width: 12),
                _GenderBox(
                  iconSvg: AppIcons.maleicon,
                  isSelected: selectedGender == 'male',
                  onTap: () => _selectGender('male'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GenderBox extends StatelessWidget {
  final String iconSvg;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderBox({
    required this.iconSvg,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.premier : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [AppColors.defaultShadow],
        ),
        child: Center(child: SvgPicture.string(iconSvg, width: 48, height: 48)),
      ),
    );
  }
}
