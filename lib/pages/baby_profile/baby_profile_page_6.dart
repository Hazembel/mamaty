import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_checkbox.dart'; // ✅ your reusable checkbox

class BabyProfilePage6 extends StatefulWidget {
  final Baby babyProfileData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BabyProfilePage6({
    super.key,
    required this.babyProfileData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BabyProfilePage6> createState() => _BabyProfilePage6State();
}

class _BabyProfilePage6State extends State<BabyProfilePage6> {
  String? selectedAllergy;

  final List<String> allergies = [
    'Aucune',
    'Produit Laitier',
    'Gluten',
    'Oeuf',
    'Soja',
    'Cacahuètes',
    'Fruits sec',
  ];

  @override
  void initState() {
    super.initState();
    selectedAllergy = widget.babyProfileData.allergy ?? allergies.first;
  }

  void _onAllergySelected(String allergy) {
    setState(() {
      selectedAllergy = allergy;
    });
    widget.babyProfileData.allergy = allergy;
  }

  void _validateAndContinue() {
    widget.babyProfileData.allergy = selectedAllergy;
    debugPrint('✅ Selected allergy: ${widget.babyProfileData.allergy}');
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
            AppTopBar(currentStep: 7, totalSteps: 7, onBack: widget.onBack),

            const SizedBox(height: 30),
 
            Center(
              child: Text(
                'Choisissez une allergie',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Allergy options using SvgCheckboxRow
            ...allergies.map(
              (allergy) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SvgCheckboxRow(
                  label: allergy,
                  isSelected: selectedAllergy == allergy,
                  onTap: () => _onAllergySelected(allergy),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Continue button
            AppButton(
              title: 'Continuer',
              onPressed: _validateAndContinue,
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
