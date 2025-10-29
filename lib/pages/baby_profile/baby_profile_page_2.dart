import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_measurement_ruler.dart'; // ✅ import the ruler
import '../../widgets/app_button.dart';
import '../../models/baby_profile_data.dart';
//import '../../controllers/height_controllers.dart';


class BabyProfilePage2 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
final BabyProfileData babyProfileData;
  const BabyProfilePage2({
    super.key,
    required this.onNext,
    required this.onBack,
     required this.babyProfileData,
  });

  @override
  State<BabyProfilePage2> createState() => _BabyProfilePage2State();
}

class _BabyProfilePage2State extends State<BabyProfilePage2> {
  double _height = 30; // default height in cm


 // final HeightControllers controllers = HeightControllers();

  // void _validateHeight() {
   // final h = controllers.current;
    // ✅ validate dangerous range
  //  if (h >= 10 && h <= 20) {
  //    debugPrint('Dangerous part: $h');
  //  }
    // ✅ add any other validation logic if needed
 // }


 @override
  void initState() {
    super.initState();
    // ✅ Load previous weight if available, fallback to 5
    _height = widget.babyProfileData.height ?? 30;
    debugPrint('Baby height: $_height');
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
              currentStep: 2,
              totalSteps: 6,
              onBack: widget.onBack,
            ),

            const SizedBox(height: 30),

            // ✅ Question title
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

            // ✅ Measurement Ruler
            Center(
              child: MeasurementRuler(
                minValue: 0,
                maxValue: 120,
                initialValue: _height,
                onChanged: (value) {
                  setState(() {
                    _height = value;
                   // controllers.current = value;
                    widget.babyProfileData.height = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 117),

            

            AppButton(
              title: 'Continuer',
               onPressed: () {
           //     _validateHeight();  
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
