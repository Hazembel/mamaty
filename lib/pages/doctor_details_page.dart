import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_top_bar_text.dart';
import '../widgets/app_doctor_card_vertical.dart';
import '../widgets/app_button.dart';
import '../widgets/app_location_button.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../models/doctor_data.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({
    super.key,
    required this.doctor,
  });

  /// 📞 Call the doctor using phone number
  Future<void> _contactDoctor(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('❌ Could not launch $phoneUri');
    }
  }

  /// 📍 Open Google Maps with address
  Future<void> _openLocation(String address) async {
    final Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not open maps for $address');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        title,
        style: AppTextStyles.inter16SemiBold.copyWith(
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String text) {
    return Text(
      text,
      style: AppTextStyles.inter14Med.copyWith(
        color: AppColors.premier,
        height: 1.4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔝 Top bar with back + share + save
              AppTopBarText(
         
                showBack: true,
                showShare: true,
                showSave: true,
                onBack: () => Navigator.pop(context),
                onShare: () => debugPrint("Shared ${doctor.name}"),
                onSave: () => debugPrint("Saved ${doctor.name}"),
              ),

              const SizedBox(height: 20),

              // 🧑‍⚕️ Doctor summary card
              DoctorCardVertical(
                doctorName: doctor.name,
                specialty: doctor.specialty,
                rating: doctor.rating,
                city: doctor.city,
                imageUrl: doctor.imageUrl,
              ),

              const SizedBox(height: 25),

              // 🩺 À propos
              _buildSectionTitle("À propos"),
              _buildSectionContent(doctor.description),

              // ⏰ Horaires
              _buildSectionTitle("Horaires"),
              _buildSectionContent(doctor.workTime),

              // 📞 Numéro de téléphone
              _buildSectionTitle("Numéro de téléphone"),
              _buildSectionContent(doctor.phone),

              // 📍 Adresse
              _buildSectionTitle("Adresse"),
              _buildSectionContent(doctor.address),

     
 const SizedBox(height: 155),

              // 🚀 Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📍 Location button (left)
                  AppLocationButton(
                    onTap: () => _openLocation(doctor.address),
                  ),
      
 const SizedBox(width: 20),
                  // 📞 Contact button (right)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        title: 'Contacter',
                        size: ButtonSize.md,
                        onPressed: () => _contactDoctor(doctor.phone),
                      ),
                    ),
                  ),
                ],
              ),

             
            ],
          ),
        ),
      ),
    );
  }
}
