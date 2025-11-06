import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/app_avatar_selector.dart';
import '../../widgets/app_gender_box.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';

import '../../controllers/form_controllers.dart';
import '../../widgets/app_text_field_date.dart';

import '../../models/signup_data.dart'; // ✅ DATA

import '../../widgets/app_button.dart';
import '../../l10n/app_localizations.dart';

class SignupPage1 extends StatefulWidget {
  final SignupData signupData; // ✅ shared signup data
  final VoidCallback onNext; // ✅ callback to go to next page
  const SignupPage1({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<SignupPage1> createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  // Separate avatar lists
  final List<String> fatherAvatars = const [
    'assets/images/avatars/dad1.jpg',
    'assets/images/avatars/dad2.jpg',
    'assets/images/avatars/dad3.jpg',
    'assets/images/avatars/dad4.jpg',
  ];

  final List<String> motherAvatars = const [
    'assets/images/avatars/mom1.jpg',
    'assets/images/avatars/mom2.jpg',
    'assets/images/avatars/mom3.jpg',
    'assets/images/avatars/mom4.jpg',
  ];

  List<String> currentAvatars = [];

  int selectedAvatarIndex = 1;
  String selectedGender = 'male'; // default male

  // 🧩 Pre-fill fields when going back
  @override
  @override
  void initState() {
    super.initState();

    // Pre-fill gender
    selectedGender = widget.signupData.gender ?? 'male';
widget.signupData.gender = selectedGender;

    // Pre-fill avatars list based on gender
    currentAvatars = selectedGender == 'male' ? fatherAvatars : motherAvatars;

    // Pre-fill previously selected avatar if exists
    if (widget.signupData.avatar != null &&
        currentAvatars.contains(widget.signupData.avatar)) {
      selectedAvatarIndex = currentAvatars.indexOf(widget.signupData.avatar!);
    } else {
      selectedAvatarIndex = 1; // default avatar2
      widget.signupData.avatar = currentAvatars[selectedAvatarIndex];
    }

    // Pre-fill birthday field
    controllers.birthdayController.text = widget.signupData.birthday ?? '';
  }

  // controllers for sigup fields
  final FormControllers controllers = FormControllers();
  String? birthdayError;

  void _validateForm() {
    setState(() {
      // Validate the birthday using your controller
      birthdayError = controllers.validateBirthday(
        controllers.birthdayController.text,
      );
    });

    if (birthdayError == null) {
      // ✅ Form is valid
      debugPrint('✅ Form is valid go next ');

      // Save the birthday into shared signupData
      widget.signupData.birthday = controllers.birthdayController.text;

      // Go to next page
      widget.onNext();
    } else {
      // ❌ Form invalid
      debugPrint('❌ Form has errors');
      
    }
  }

  void _onGenderSelected(String gender) {
    if (gender == selectedGender) return; // no change, do nothing

    setState(() {
      selectedGender = gender;

      // Update avatars list
      currentAvatars = gender == 'male' ? fatherAvatars : motherAvatars;

      // Preserve avatar if possible
      if (widget.signupData.avatar != null &&
          currentAvatars.contains(widget.signupData.avatar)) {
        selectedAvatarIndex = currentAvatars.indexOf(widget.signupData.avatar!);
      } else {
        selectedAvatarIndex = 0; // fallback to first avatar in list
        widget.signupData.avatar = currentAvatars[selectedAvatarIndex];
      }
    });

    debugPrint('Selected gender: $gender');
    widget.signupData.gender = gender; // save
  }

  void _onAvatarSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        selectedAvatarIndex = index;
      });

      debugPrint('Selected avatar: ${currentAvatars[index]}');
      widget.signupData.avatar = currentAvatars[index];
    });
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
            const AppTopBar(),

            const SizedBox(height: 30),

            Text(
              'Inscrivez-vous pour commencer',
              style: AppTextStyles.inter24Bold.copyWith(
                color: AppColors.premier,
              ),
            ),

            const SizedBox(height: 30),

            // Avatar selector
            AvatarSelector(
              avatars: currentAvatars,
              size: 120,
              onAvatarSelected: _onAvatarSelected,
              initialSelectedIndex: selectedAvatarIndex, // ✅ important
            ),

            const SizedBox(height: 10),

            AppTextFieldDate(
              labelText:
                  AppLocalizations.of(context)?.birthday ?? 'Date de naissance',
              controller: controllers.birthdayController,
              errorText: birthdayError,
            ),

            const SizedBox(height: 20),

            // Gender selector
            GenderSelector(
              defaultGender: selectedGender, // male by default
              onGenderSelected: _onGenderSelected,
            ),

            const SizedBox(height: 30),

            // button for form validation
            const SizedBox(height: 20),

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
