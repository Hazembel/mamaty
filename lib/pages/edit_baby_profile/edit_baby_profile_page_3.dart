import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_weight_ruler.dart'; // ✅ import the weight ruler
import '../../widgets/app_button.dart';
import '../../models/baby.dart';
 

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

  @override
  void initState() {
    super.initState();
    // ✅ Load previous weight if available, fallback to 5
    _weight = widget.babyProfileData.weight ?? 5;
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
            // Top bar with step
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

            // Weight Ruler
            Center(
              child: WeightRuler(
                minValue: 0,
                maxValue: 50,
                initialValue: _weight,
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                    // ✅ Save back to babyProfileData so it persists
                    widget.babyProfileData.weight = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 117),

            AppButton(
              title: 'Continuer',
              onPressed: () {
                widget.onNext();
              },
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
