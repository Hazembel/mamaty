import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_head_size.dart'; // ✅ vertical ruler for head size
import '../../widgets/app_button.dart';
import '../../models/baby.dart';
 

class EditBabyProfilePage7 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Baby babyProfileData;

  const EditBabyProfilePage7({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.babyProfileData,
  });

  @override
  State<EditBabyProfilePage7> createState() => _EditBabyProfilePage7State();
}

class _EditBabyProfilePage7State extends State<EditBabyProfilePage7> {
  late double _headSize;

  @override
  void initState() {
    super.initState();
    // Load previous head size if available, fallback to 5
    _headSize = widget.babyProfileData.headSize ?? 5;
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
            AppTopBar(currentStep: 4, totalSteps: 7, onBack: widget.onBack),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Quelle est la taille de sa tête ?',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Head Size Ruler
            Center(
              child: VerticalMeasurementRuler(
                minValue: 5, // minimum head circumference in cm
                maxValue: 60, // maximum head circumference
                initialValue: _headSize,
                onChanged: (value) {
                  setState(() {
                    _headSize = value;
                    // Save to babyProfileData
                    widget.babyProfileData.headSize = value;
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
