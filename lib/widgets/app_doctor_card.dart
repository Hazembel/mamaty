import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Assuming these imports lead to your theme files
import '../theme/border_radius.dart'; // Ensure AppBorders.smallRadius is defined here
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../icons/app_icons.dart' ;

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final double rating;
  final String distance;
  final String imageUrl;

  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Replaced Card with Container to use custom BoxShadow
    return Container(
      margin: EdgeInsets.zero, // GridView handles spacing, so no external margin here
      decoration: BoxDecoration(
        color: AppColors.white, // Background color for the container
                            borderRadius: BorderRadius.circular(AppBorders.defaultRadius),

        boxShadow: [AppColors.defaultShadow], // <--- Applying your custom shadow here
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced overall padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Doctor Image - Reduced radius for a smaller image
            CircleAvatar(
              radius: 35, // Significantly reduced radius from 50 to 35
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: AppColors.background,
            ),
            const SizedBox(height: 6),

            // Doctor Name
            Text(
              doctorName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.inter12Reg.copyWith(
                color: AppColors.premier,
              ),
            ),
            const SizedBox(height: 2),

            // Specialty
            Text(
              specialty,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.inter9Med.copyWith(
                color: AppColors.lightPremier,
              ),
            ),
            const SizedBox(height: 8),

            // Rating and Distance Row
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.shadow,
                      borderRadius: BorderRadius.circular(AppBorders.smallRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.string(
                          AppIcons.star,
                          width: 8,
                          height: 8,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyles.inter8Med.copyWith(
                              color: AppColors.lightPremier,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Distance
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.string(
                          AppIcons.location,
                          width: 8,
                          height: 8,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            distance,
                            style: AppTextStyles.inter8Med.copyWith(
                              color: AppColors.lightPremier,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}