import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../models/baby.dart';
import 'package:intl/intl.dart';

class HomeHeaderCard extends StatelessWidget {
  final Baby baby;
  final String userName;
  final String? userAvatar;
  final VoidCallback? onBabyTap; // <-- new
  final VoidCallback? onUserTap; // <-- new

  const HomeHeaderCard({
    super.key,
    required this.baby,
    required this.userName,
    this.userAvatar,
    this.onBabyTap,
    this.onUserTap,
  });

  int _calculateDaysOld(String? birthdayString) {
    if (birthdayString == null || birthdayString.isEmpty) return 0;

    try {
      final format = DateFormat('dd/MM/yyyy');
      final birthday = format.parseStrict(birthdayString);
      return DateTime.now().difference(birthday).inDays;
    } catch (e) {
      debugPrint('❌ Failed to parse birthday: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int days = _calculateDaysOld(baby.birthday);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👶 Baby Avatar (left)
          GestureDetector(
            onTap: onBabyTap, // <-- handle baby tap
            child: CircleAvatar(
              radius: 25,
              backgroundImage: baby.avatar != null
                  ? NetworkImage(baby.avatar!)
                  : const AssetImage('assets/images/default_baby.png')
                        as ImageProvider,
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
          GestureDetector(
            onTap: onUserTap, // <-- handle user tap
            child: CircleAvatar(
              radius: 25,
              backgroundImage: userAvatar != null
                  ? NetworkImage(userAvatar!)
                  : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
            ),
          ),
        ],
      ),
    );
  }
}
