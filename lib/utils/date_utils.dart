import 'package:flutter/foundation.dart';

class DateUtilsHelper {
  /// Calculate age in days from birthday string
  /// Supports "yyyy-MM-dd" and "dd/MM/yyyy"
  static int calculateAgeInDays(String? birthday) {
    if (birthday == null || birthday.isEmpty) return 0;

    DateTime? birthDate;

    // Try ISO first (yyyy-MM-dd)
    birthDate = DateTime.tryParse(birthday);

    // Try dd/MM/yyyy manually if ISO fails
    if (birthDate == null && birthday.contains('/')) {
      try {
        final parts = birthday.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          birthDate = DateTime(year, month, day);
        }
      } catch (e) {
        debugPrint('⚠️ Failed to parse birthday: $e');
        return 0;
      }
    }

    if (birthDate == null) return 0;

    final ageInDays = DateTime.now().difference(birthDate).inDays;
    return ageInDays < 0 ? 0 : ageInDays;
  }
}
