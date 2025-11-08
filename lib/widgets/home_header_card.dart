import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../models/baby.dart';
import 'package:intl/intl.dart';

class HomeHeaderCard extends StatelessWidget {
  final Baby baby;
  final String userName;
  final String? userAvatar;
  final VoidCallback? onBabyTap;
  final VoidCallback? onUserTap;

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

  ImageProvider _getImageProvider(String? path, String defaultAsset) {
    if (path == null || path.isEmpty) {
      return AssetImage(defaultAsset);
    }
    // If path is a network URL
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }
    // Otherwise treat as local asset
    return AssetImage(path);
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
            onTap: onBabyTap,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: _getImageProvider(
                  baby.avatar, 'assets/images/default_baby.png'),
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
            onTap: onUserTap,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: _getImageProvider(
                  userAvatar, 'assets/images/default_user.png'),
            ),
          ),
        ],
      ),
    );
  }
}
