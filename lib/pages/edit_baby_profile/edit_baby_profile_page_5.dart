import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_checkbox.dart';
import '../../widgets/app_snak_bar.dart';

class EditBabyProfilePage5 extends StatefulWidget {
  final Baby babyProfileData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EditBabyProfilePage5({
    super.key,
    required this.babyProfileData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<EditBabyProfilePage5> createState() => _EditBabyProfilePage5State();
}

class _EditBabyProfilePage5State extends State<EditBabyProfilePage5> {
  String? selectedDisease;

  final List<String> diseases = [
    'Aucune',
    'Reflux Gastro-Oesphagien',
    'Troubles Digestifs',
    'Troubles innés',
    'Diabetes Type 1',
    'Malnutrition',
  ];

  @override
  void initState() {
    super.initState();
    selectedDisease = widget.babyProfileData.disease ?? 'Aucune';
  }

  void _onDiseaseSelected(String disease) {
    setState(() {
      selectedDisease = disease;
    });
    widget.babyProfileData.disease = disease;
  }

void _validateAndContinue() async {
  // If the selected disease is not "Aucune"
  if (selectedDisease != 'Aucune') {
    AppSnackBar.show(
      context,
      message:
             "⚠️ Votre bébé a était malade.\n"
          "Veuillez vérifier cette information a l'accueil.\n",
      backgroundColor: Colors.orange,
      durationSeconds: 4,
    );

    // ⏳ Wait for the SnackBar to finish showing
    await Future.delayed(const Duration(seconds:5));

    // ➜ Then continue automatically
    widget.babyProfileData.disease = selectedDisease;
    widget.onNext();
    return;
  }

  // Normal flow when disease == Aucune
  widget.babyProfileData.disease = selectedDisease;
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
            AppTopBar(currentStep: 5, totalSteps: 6, onBack: widget.onBack),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Choisissez une maladie',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Disease options using SvgCheckboxRow
            ...diseases.map(
              (disease) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SvgCheckboxRow(
                  label: disease,
                  isSelected:
                      selectedDisease?.toLowerCase() == disease.toLowerCase(),
                  onTap: () => _onDiseaseSelected(disease),
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
