import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart'; 
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby_profile_data.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_create_bebe.dart';

class BabyProfilePage1 extends StatefulWidget {
  final BabyProfileData babyData;
  final VoidCallback onNext;

  const BabyProfilePage1({
    super.key,
    required this.babyData,
    required this.onNext,
  });

  @override
  State<BabyProfilePage1> createState() => _BabyProfilePage1State();
}

class _BabyProfilePage1State extends State<BabyProfilePage1> {
  final TextEditingController _nameController = TextEditingController();
  String? nameError;

  @override

  void initState() {
    super.initState();
    _nameController.text = widget.babyData.name ?? '';
  }

  void _validateAndNext() {
    setState(() {
      nameError = _nameController.text.isEmpty ? 'Entrez un nom' : null;
    });

    if (nameError == null) {
      widget.babyData.name = _nameController.text;
      widget.onNext();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            // ✅ Step in top bar
            AppTopBar(
              currentStep: 1,
              totalSteps: 6,
            ),
            const SizedBox(height: 30),
            Text(
              'Créez le profil de ton bébé !',
              style: AppTextStyles.inter24Bold.copyWith(
                color: AppColors.premier,
              ),
            ),
            const SizedBox(height: 55),
          
          ],
        ),
      ),
    );
  }
}
