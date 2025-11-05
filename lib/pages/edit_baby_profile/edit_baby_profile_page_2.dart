import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_measurement_ruler.dart';
import '../../widgets/app_button.dart';
import '../../models/baby.dart';
import '../../controllers/height_controllers.dart';
import '../../widgets/custom_alert_modal.dart';

class EditBabyProfilePage2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Baby babyProfileData;

  const EditBabyProfilePage2({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.babyProfileData,
  });

  @override
  State<EditBabyProfilePage2> createState() => _EditBabyProfilePage2State();
}

class _EditBabyProfilePage2State extends State<EditBabyProfilePage2> {
  late double _height;

  //************ */ Calculate age in days
  int _calculateAgeInDays(String? birthday) {
    if (birthday == null || birthday.isEmpty) return 0;

    DateTime? birthDate;

    // Try ISO first (yyyy-MM-dd)
    birthDate = DateTime.tryParse(birthday);

    // Try dd/MM/yyyy manually if needed
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

  @override
  void initState() {
    super.initState();
    _height = widget.babyProfileData.height ?? 30;

    final ageInDays = _calculateAgeInDays(widget.babyProfileData.birthday);
    debugPrint(
      '📏 Editing baby: ${widget.babyProfileData.name ?? 'Unknown'} | '
      'Birthday: ${widget.babyProfileData.birthday ?? 'N/A'} | '
      'Age in days: $ageInDays | Height: $_height cm',
    );
  }

  Future<void> _onContinue() async {
    final baby = widget.babyProfileData;
    baby.height ??= _height;

    final ageInDays = _calculateAgeInDays(baby.birthday);

    // ✅ Validate height
    final error = HeightController.validateHeight(
      height: baby.height!,
      ageInDays: ageInDays,
      gender: baby.gender ?? 'male',
    );

    if (error != null) {
      await CustomAlertModal.show(
        context,
        title: 'Attention médicale requise',
        message:
            'La taille actuelle de votre bébé semble en dehors de la plage normale pour son âge. '
            'Il est conseillé de consulter un professionnel de santé afin de vérifier sa croissance et son développement.',
        primaryText: 'Consulter',
        secondaryText: 'Continuer',
        onPrimary: () async {
          await Navigator.of(context).pushNamed('/doctors');
        },
        onSecondary: () {
          widget.babyProfileData.height = _height;
          widget.onNext();
        },
      );
      return;
    }

    // ✅ Normal case
    widget.babyProfileData.height = _height;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppDimensions.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(
              currentStep: 2,
              totalSteps: 6,
              onBack: widget.onBack,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Quelle est sa taille ?',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: MeasurementRuler(
                minValue: 0,
                maxValue: 120,
                initialValue: _height,
                onChanged: (value) {
                  setState(() {
                    _height = value;
                    widget.babyProfileData.height = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 117),
            AppButton(
              title: 'Continuer',
              onPressed: _onContinue,
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
