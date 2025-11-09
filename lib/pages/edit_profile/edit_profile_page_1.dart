import 'package:flutter/material.dart';
import '../../widgets/app_bar_profile.dart';
import '../../widgets/app_avatar_selector.dart';
import '../../widgets/app_gender_box.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../favorite_page.dart';


import '../../controllers/form_controllers.dart';
import '../../widgets/app_text_field_date.dart';

import '../../models/signup_data.dart'; // ✅ DATA

import '../../widgets/app_button.dart';
import '../../l10n/app_localizations.dart';
import '../faq_page.dart';

class Editprofile1 extends StatefulWidget {
  final SignupData editProfileData; // ✅ shared signup data
  final VoidCallback onNext; // ✅ callback to go to next page
  const Editprofile1({
    super.key,
    required this.editProfileData,
    required this.onNext,
  });

  @override
  State<Editprofile1> createState() => _Editprofile1State();
}

class _Editprofile1State extends State<Editprofile1> {
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
    selectedGender = widget.editProfileData.gender ?? 'male';
widget.editProfileData.gender = selectedGender;

    // Pre-fill avatars list based on gender
    currentAvatars = selectedGender == 'male' ? fatherAvatars : motherAvatars;

    // Pre-fill previously selected avatar if exists
    if (widget.editProfileData.avatar != null &&
        currentAvatars.contains(widget.editProfileData.avatar)) {
      selectedAvatarIndex = currentAvatars.indexOf(widget.editProfileData.avatar!);
    } else {
      selectedAvatarIndex = 1; // default avatar2
      widget.editProfileData.avatar = currentAvatars[selectedAvatarIndex];
    }

    // Pre-fill birthday field
    controllers.birthdayController.text = widget.editProfileData.birthday ?? '';
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

      // Save the birthday into shared editProfileData
      widget.editProfileData.birthday = controllers.birthdayController.text;

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
      if (widget.editProfileData.avatar != null &&
          currentAvatars.contains(widget.editProfileData.avatar)) {
        selectedAvatarIndex = currentAvatars.indexOf(widget.editProfileData.avatar!);
      } else {
        selectedAvatarIndex = 0; // fallback to first avatar in list
        widget.editProfileData.avatar = currentAvatars[selectedAvatarIndex];
      }
    });

    debugPrint('Selected gender: $gender');
    widget.editProfileData.gender = gender; // save
  }

  void _onAvatarSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        selectedAvatarIndex = index;
      });

      debugPrint('Selected avatar: ${currentAvatars[index]}');
      widget.editProfileData.avatar = currentAvatars[index];
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
AppProfileBar(
  onBack: () => Navigator.of(context).pop(),       // left back button
  onFaq: () { Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const FaqPage ()),
); },   
  isSaved: false,                                  // show save button
  onSaveToggle: () {
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const FavoritePage ()),
);
  },
),


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
