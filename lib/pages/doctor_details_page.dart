import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/app_top_bar_text.dart';
import '../widgets/app_doctor_card_vertical.dart';
import '../widgets/app_button.dart';
import '../widgets/app_location_button.dart';
import '../theme/colors.dart';
 
import '../theme/text_styles.dart';
import '../models/doctor.dart';
import '../providers/user_provider.dart';
import '../services/doctor_service.dart';
import '../widgets/app_snak_bar.dart';
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
  // Clean the phone number (remove spaces)
  final cleanedPhone = phone.replaceAll(' ', '');
  final Uri phoneUri = Uri.parse('tel:$cleanedPhone');

  try {
    // Try to launch the phone dialer
    await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('❌ Could not launch phone dialer: $e');
  }
}


Future<void> _openLocation(String address) async {
  final encodedAddress = Uri.encodeComponent(address);

  // Try to open the Google Maps app (Android)
  final Uri googleMapsAppUri = Uri.parse("geo:0,0?q=$encodedAddress");

  // Try the universal Google Maps website (fallback)
  final Uri googleMapsWebUri = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$encodedAddress",
  );

  try {
    // If the Google Maps app is available
    if (await canLaunchUrl(googleMapsAppUri)) {
      await launchUrl(googleMapsAppUri, mode: LaunchMode.externalApplication);
      return;
    }

    // Otherwise open Google Maps on the browser
    if (await canLaunchUrl(googleMapsWebUri)) {
      await launchUrl(googleMapsWebUri, mode: LaunchMode.externalApplication);
      return;
    }

    debugPrint("❌ No app or browser available to open maps.");
  } catch (e) {
    debugPrint("❌ Error opening maps: $e");
  }
}


Future<void> _toggleFavorite(UserProvider userProvider) async {
  final doctorId = widget.doctor.id;
  if (doctorId == null) return;

  // ✅ Optimistic update: toggle locally immediately
  final wasFavorite = userProvider.user?.doctors.contains(doctorId) ?? false;
  setState(() {
    if (wasFavorite) {
      userProvider.user?.doctors.remove(doctorId);
    } else {
      userProvider.user?.doctors.add(doctorId);
    }
  });

  try {
    // Call backend asynchronously
    await DoctorService.toggleFavoriteDoctor(doctorId);

    // Update provider to ensure consistency
    await userProvider.toggleFavoriteDoctor(doctorId);

    if (!mounted) return;

    // Show success message
    final isFavorite = userProvider.user?.doctors.contains(doctorId) ?? false;
    AppSnackBar.show(
      context,
      message: isFavorite
          ? "Le médecin a été ajouté aux favoris ❤️"
          : "Le médecin a été retiré des favoris 💔",
    );
  } catch (e) {
    debugPrint('❌ Failed to toggle favorite: $e');

    // Rollback UI if backend fails
    if (mounted) {
      setState(() {
        if (wasFavorite) {
          userProvider.user?.doctors.add(doctorId);
        } else {
          userProvider.user?.doctors.remove(doctorId);
        }
      });
    }

    if (!mounted) return;

    // Show error message
    AppSnackBar.show(
      context,
      message: "Impossible de modifier les favoris.",
      backgroundColor: Colors.redAccent,
    );
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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

  await SharePlus.instance.share(
    ShareParams(
      text: shareText, // the text to share
      title: 'Partager le profil du docteur', // optional
    ),
  );
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

     

          // Push bottom buttons to bottom if there’s extra space
     SizedBox(height: MediaQuery.of(context).size.height * 0.2), 

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
                       
          const SizedBox(height: 10),
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
