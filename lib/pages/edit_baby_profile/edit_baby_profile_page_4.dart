import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/app_avatar_selector.dart';
import '../../widgets/app_gender_box.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../controllers/form_controllers.dart';
import '../../widgets/app_text_field_date.dart';
import '../../models/baby_profile_data.dart';
import '../../widgets/app_button.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_text_field.dart';

class EditBabyProfilePage4 extends StatefulWidget {
  final BabyProfileData babyProfileData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EditBabyProfilePage4({
    super.key,
    required this.babyProfileData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<EditBabyProfilePage4> createState() => _EditBabyProfilePage4State();
}

class _EditBabyProfilePage4State extends State<EditBabyProfilePage4> {
  // ✅ Avatar lists
  final List<String> boyAvatars = const [
    'assets/images/avatars/baby_boy1.jpg',
    'assets/images/avatars/baby_boy2.jpg',
  ];

  final List<String> girlAvatars = const [
    'assets/images/avatars/baby_girl1.jpg',
    'assets/images/avatars/baby_girl2.jpg',
  ];

  List<String> currentAvatars = [];
  int selectedAvatarIndex = 0;
  String selectedGender = 'male';

  final FormControllers controllers = FormControllers();

  String? nameError;
  String? birthdayError;

  @override
  void initState() {
    super.initState();

    // ✅ Load previous gender if exists, otherwise default
    selectedGender = widget.babyProfileData.gender ?? 'male';
    currentAvatars = selectedGender == 'male' ? boyAvatars : girlAvatars;

    // ✅ If avatar exists, find its index
    if (widget.babyProfileData.avatar != null &&
        currentAvatars.contains(widget.babyProfileData.avatar)) {
      selectedAvatarIndex =
          currentAvatars.indexOf(widget.babyProfileData.avatar!);
    } else {
      // If gender was changed before, reset to first avatar of that gender
      selectedAvatarIndex = 0;
      widget.babyProfileData.avatar = currentAvatars.first;
    }

    // ✅ Preload form fields
    controllers.lastnameController.text = widget.babyProfileData.name ?? '';
    controllers.birthdayController.text =
        widget.babyProfileData.birthday ?? '';
  }

  // ✅ Update gender + refresh avatars + keep old avatar if same gender
  void _onGenderSelected(String gender) {
    if (gender == selectedGender) return;

    setState(() {
      selectedGender = gender;
      currentAvatars = gender == 'male' ? boyAvatars : girlAvatars;

      // When switching gender, reset avatar to first of new list
      selectedAvatarIndex = 0;
      widget.babyProfileData.avatar = currentAvatars.first;
    });

    widget.babyProfileData.gender = gender;
  }

  // ✅ Avatar change
  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatarIndex = index;
      widget.babyProfileData.avatar = currentAvatars[index];
    });
  }

  // ✅ Validate + Save
  void _validateForm() {
    setState(() {
      nameError = controllers.lastnameController.text.isEmpty
          ? 'Veuillez saisir le nom'
          : null;

      birthdayError = controllers.birthdayController.text.isEmpty
          ? 'Veuillez entrer la date de naissance'
          : null;
    });

    if (nameError == null && birthdayError == null) {
      widget.babyProfileData.name = controllers.lastnameController.text;
      widget.babyProfileData.birthday = controllers.birthdayController.text;
      widget.babyProfileData.gender = selectedGender;
      widget.babyProfileData.avatar = currentAvatars[selectedAvatarIndex];

      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez corriger les erreurs ❗')),
      );
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
            AppTopBar(
              currentStep: 5,
              totalSteps: 7,
              onBack: widget.onBack,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Modifier le profil de votre bébé',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Avatar selector with initial selection restored
            AvatarSelector(
              avatars: currentAvatars,
              size: 120,
              onAvatarSelected: _onAvatarSelected,
              initialSelectedIndex: selectedAvatarIndex,
            ),

            const SizedBox(height: 20),

            // Baby name input
            AppTextField(
              labelText: 'Nom du bébé',
              controller: controllers.lastnameController,
              errorText: nameError,
            ),

            const SizedBox(height: 20),

            // Birthday input
            AppTextFieldDate(
              labelText:
                  AppLocalizations.of(context)?.birthday ?? 'Date de naissance',
              controller: controllers.birthdayController,
              errorText: birthdayError,
            ),

            const SizedBox(height: 20),

            // ✅ Gender selector now shows the saved gender
            GenderSelector(
              defaultGender: selectedGender,
              onGenderSelected: _onGenderSelected,
            ),

            const SizedBox(height: 40),

            AppButton(
              title: 'Continuer',
              onPressed: _validateForm,
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
