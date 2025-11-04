import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_head_size.dart'; // ✅ vertical ruler for head size
import '../../widgets/app_button.dart';
import '../../models/baby.dart';
import '../../widgets/custom_alert_modal.dart';

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
  late double _oldHeadSize;
  bool _canEditHeadSize = true;
  int _daysSinceLastUpdate = 0;

  @override
  void initState() {
    super.initState();

    _oldHeadSize = widget.babyProfileData.headSize ?? 5;
    _headSize = _oldHeadSize;

    final lastUpdate = widget.babyProfileData.lastheadsizeUpdate;
    if (lastUpdate != null) {
      final now = DateTime.now();
      _daysSinceLastUpdate = now.difference(lastUpdate).inDays;
      if (_daysSinceLastUpdate < 7) {
        _canEditHeadSize = false;
      }
    }
  }




Future<void> _onContinue() async {
  if (_headSize < _oldHeadSize) {
    debugPrint('⚠️ New head size ($_headSize) < previous ($_oldHeadSize)');

    await CustomAlertModal.show(
      context,
      title: 'Attention médicale requise',
      message:
          'La nouvelle mesure de la tête est inférieure à la précédente. Ce cas nécessite une consultation médicale pour garantir le bon suivi de la croissance de votre bébé.',
      primaryText: 'Consulter',
      secondaryText: 'Continuer',
      onPrimary: () async {
        // Navigate to DoctorsPage
        await Navigator.of(context).pushNamed('/doctors');
        // You can optionally continue after returning from DoctorsPage
      },
      onSecondary: () {
        // Just close the modal and continue
        Navigator.of(context).pop();
      },
    );

    // Save head size and continue
    widget.babyProfileData.headSize = _headSize;
    widget.onNext();
    return;
  }

  // Normal case: head size is fine
  widget.babyProfileData.headSize = _headSize;
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
            if (!_canEditHeadSize) ...[
              Center(
                child: Text(
                  'La taille de la tête peut être mise à jour après ${7 - _daysSinceLastUpdate} jours.',
                  style: AppTextStyles.inter14Med.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Center(
              child: VerticalMeasurementRuler(
                minValue: 5,
                maxValue: 60,
                initialValue: _headSize,
                enabled: _canEditHeadSize,
                onChanged: (value) {
                  if (!_canEditHeadSize) return;
                  setState(() {
                    _headSize = value;
                    // Don't update babyProfileData yet
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
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
