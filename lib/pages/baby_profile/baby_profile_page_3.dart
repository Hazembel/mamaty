import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_weight_ruler.dart'; // ✅ import the weight ruler
import '../../widgets/app_button.dart';
import '../../models/baby_profile_data.dart';
import '../../controllers/weight_controllers.dart'; // ✅ new controller

class BabyProfilePage3 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final BabyProfileData babyProfileData;

  const BabyProfilePage3({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.babyProfileData,
  });

  @override
  State<BabyProfilePage3> createState() => _BabyProfilePage3State();
}

class _BabyProfilePage3State extends State<BabyProfilePage3> {
  double _weight = 5; // default weight in kg
  final WeightControllers controllers = WeightControllers();

  void _validateWeight() {
    final w = controllers.current;

    // ✅ Example validation logic
    if (w >= 1 && w <= 2) {
      debugPrint('⚠️ Danger: very low weight ($w kg)');
    } else if (w > 20) {
      debugPrint('⚠️ Danger: very high weight ($w kg)');
    } else {
      debugPrint('✅ Normal weight: $w kg');
    }
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
            // ✅ Top bar with steps
            AppTopBar(
              currentStep: 3,
              totalSteps: 6,
              onBack: widget.onBack,
            ),

            const SizedBox(height: 30),

            // ✅ Question title
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

            // ✅ Weight Ruler
            Center(
              child: WeightRuler(
                minValue: 0,
                maxValue: 50,
                initialValue: _weight,
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                    controllers.current = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 117),

            // ✅ Continue button
            AppButton(
              title: 'Continuer',
              onPressed: () {
                _validateWeight();
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
