import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_weight_ruler.dart';
import '../../widgets/app_button.dart';
import '../../models/baby.dart';
import '../../controllers/weight_controllers.dart';
import '../../widgets/custom_alert_modal.dart';

class EditBabyProfilePage3 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Baby babyProfileData;

  const EditBabyProfilePage3({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.babyProfileData,
  });

  @override
  State<EditBabyProfilePage3> createState() => _EditBabyProfilePage3State();
}

class _EditBabyProfilePage3State extends State<EditBabyProfilePage3> {
  late double _weight;

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

  _weight = widget.babyProfileData.weight ?? 5;

  // 🧮 Calculate age in days
  final ageInDays = _calculateAgeInDays(widget.babyProfileData.birthday);

  // 🪵 Debug log to confirm which baby and what age
  debugPrint(
    '🍼 Editing baby: ${widget.babyProfileData.name ?? 'Unknown'} | '
    'Birthday: ${widget.babyProfileData.birthday ?? 'N/A'} | '
    'Age in days: $ageInDays',
  );
}


  Future<void> _onContinue() async {
    final baby = widget.babyProfileData;
    baby.weight ??= _weight;

    // ✅ Validate using controller
    final ageInDays = _calculateAgeInDays(baby.birthday);
    final error = WeightController.validateWeight(
      weight: baby.weight!,
      ageInDays: ageInDays,
      gender: baby.gender ?? 'male',
    );

    if (error != null) {
      // 🚨 Show alert if invalid
    await CustomAlertModal.show(
      context,
      title: 'Attention médicale requise',
      message:
          'Le poids actuel de votre bébé semble en dehors de la plage normale pour son âge. Il est conseillé de consulter un professionnel de santé afin de vérifier son état de croissance et d’assurer un suivi adapté',
      primaryText: 'Consulter',
      secondaryText: 'Continuer',
      onPrimary: () async {
        // Navigate to DoctorsPage
        await Navigator.of(context).pushNamed('/doctors');
        // You can optionally continue after returning from DoctorsPage
      },
      onSecondary: () {
        widget.babyProfileData.weight = _weight;
        widget.onNext();
       
      },
    );
   
      return; // stop here
    }

    // ✅ All good → continue
    widget.babyProfileData.weight = _weight;
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
              currentStep: 3,
              totalSteps: 6,
              onBack: widget.onBack,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Quel est son poids actuel ?',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: WeightRuler(
                minValue: 0,
                maxValue: 50,
                initialValue: _weight,
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                    widget.babyProfileData.weight = value;
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
