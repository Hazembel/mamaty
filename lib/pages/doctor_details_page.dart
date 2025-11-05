import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/app_top_bar_text.dart';
import '../widgets/app_doctor_card_vertical.dart';
import '../widgets/app_button.dart';
import '../widgets/app_location_button.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';
import '../models/doctor.dart';
import '../providers/user_provider.dart';
import '../services/doctor_service.dart';

class DoctorDetailsPage extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailsPage({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  bool _isSaving = false;

  Future<void> _contactDoctor(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('❌ Could not launch $phoneUri');
    }
  }

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

  Future<void> _toggleFavorite(UserProvider userProvider) async {
    setState(() => _isSaving = true);
    try {
      await DoctorService.toggleFavoriteDoctor(widget.doctor.id);
      userProvider.toggleFavoriteDoctor(widget.doctor.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Favorite toggled successfully!'),
          backgroundColor: AppColors.premier,
        ),
      );
    } catch (e) {
      debugPrint('❌ Failed to toggle favorite: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to toggle favorite.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final userProvider = Provider.of<UserProvider>(context);

    final isSaved = userProvider.user?.doctors.contains(doctor.id) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBarText(
                showBack: true,
                showShare: true,
                showSave: true,
                onBack: () => Navigator.pop(context),
                onShare: () async {
                  final shareText =
                      "Découvrez le Dr. ${doctor.name}, spécialiste en ${doctor.specialty}, situé à ${doctor.city}.";
                  await Share.share(shareText);
                },
                isSaved: isSaved,
                onToggleSave: _isSaving
                    ? null
                    : () => _toggleFavorite(userProvider),
              ),

              const SizedBox(height: 20),

              DoctorCardVertical(
                doctorName: doctor.name,
                specialty: doctor.specialty,
                rating: doctor.rating,
                city: doctor.city,
                imageUrl: doctor.imageUrl,
              ),

              const SizedBox(height: 25),

              _buildSectionTitle("À propos"),
              _buildSectionContent(doctor.description),

              _buildSectionTitle("Horaires"),
              _buildSectionContent(doctor.workTime),

              _buildSectionTitle("Numéro de téléphone"),
              _buildSectionContent(doctor.phone),

              _buildSectionTitle("Adresse"),
              _buildSectionContent(doctor.address),

              const SizedBox(height: 155),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLocationButton(
                    onTap: () => _openLocation(doctor.address),
                  ),
                  const SizedBox(width: 20),
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
}
