// lib/widgets/doctor_card_vertical.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/border_radius.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../icons/app_icons.dart';

class DoctorCardVertical extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final double rating;
  final String city;
  final String imageUrl;

  const DoctorCardVertical({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.city,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppBorders.defaultRadius),
       
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👨‍⚕️ Doctor photo on the left
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: AppColors.background,
          ),
          const SizedBox(width: 20),

          // 🩺 Right side info (name, specialty, rating, location)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  doctorName,
                  style: AppTextStyles.inter16SemiBold.copyWith(
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),

                // Specialty
                Text(
                  specialty,
                  style: AppTextStyles.inter12Med.copyWith(
                    color: AppColors.premier,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),

                // ⭐ Rating
               Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorders.smallRadius),
                    border: Border.all(color: AppColors.premier, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.string(
                        AppIcons.star,
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.inter12bold.copyWith(
                            color: AppColors.lightPremier,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // 📍 Location / City
                Row(
                  children: [
                    SvgPicture.string(AppIcons.location, width: 12, height: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        city,
                        style: AppTextStyles.inter12bold.copyWith(
                          color: AppColors.lightPremier,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
