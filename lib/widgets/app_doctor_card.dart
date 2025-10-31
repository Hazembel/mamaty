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
  final String city;
  final String imageUrl;

  const DoctorCard({
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
      margin: EdgeInsets.zero,
      
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorders.defaultRadius),
        boxShadow: [AppColors.defaultShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric( ), // Slightly reduced vertical padding
        
        child: Column(
          // mainAxisSize: MainAxisSize.min, // Removed to allow Column to take more space
         mainAxisAlignment: MainAxisAlignment.center, // centers vertically
    crossAxisAlignment: CrossAxisAlignment.center, // centers horizontally
          children: [
            // Doctor Image - Adjusted radius for 160x180 aspect ratio
            CircleAvatar(
              radius: 45, // Reduced radius from 35 to 30
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: AppColors.background,
            ),
            const SizedBox(height: 5), // Slightly reduced spacing

            // Doctor Name
            Text(
              doctorName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.inter14Med.copyWith(
                color: AppColors.premier,
              ),
            ),
            const SizedBox(height: 5),

            // Specialty
            Text(
              specialty,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.inter12Med.copyWith(
                color: AppColors.lightPremier,
              ),
            ),
          
               const SizedBox(height: 5),
            // Rating and city Row
            // Ensuring this part is at the bottom and uses minimal space
            Row(
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
                        width: 10,
                        height: 10,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.inter12Med.copyWith(
                            color: AppColors.lightPremier,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8 ),

                // city
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.string(
                      AppIcons.location,
                      width: 10,
                      height: 10,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        city,
                        style: AppTextStyles.inter12Med.copyWith(
                          color: AppColors.lightPremier,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}