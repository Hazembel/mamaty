import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../models/baby_profile_data.dart';

class HomeHeaderCard extends StatelessWidget {
  final BabyProfileData baby;
  final String userName;
  final String? userAvatar;

  const HomeHeaderCard({
    super.key,
    required this.baby,
    required this.userName,
    this.userAvatar,
  });

  int _calculateDaysOld() {
    try {
      final birthday = DateTime.parse(baby.birthday ?? '');
      final now = DateTime.now();
      return now.difference(birthday).inDays;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _calculateDaysOld();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👶 Baby Avatar (left)
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              baby.avatar ?? 'assets/images/default_baby.png',
            ),
          ),

          // 👋 Greeting + Day count (center)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bonjour, $userName 👋',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.inter16SemiBold.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jour $days',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.inter12bold.copyWith(
                    color: AppColors.premier,
                  ),
                ),
              ],
            ),
          ),

          // 🧍 User Avatar (right)
          CircleAvatar(
            radius: 25,
            backgroundImage: userAvatar != null
                ? AssetImage(userAvatar!)
                : const AssetImage('assets/images/default_user.png'),
          ),
        ],
      ),
    );
  }
}
