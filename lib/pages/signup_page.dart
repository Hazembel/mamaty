import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_avatar_selector.dart';
import '../widgets/app_gender_box.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/dimensions.dart';
import '../controllers/form_controllers.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Separate avatar lists
  final List<String> fatherAvatars = const [
    'assets/images/father/avatar1.jpg',
    'assets/images/father/avatar2.jpg',
    'assets/images/father/avatar3.jpg',
    'assets/images/father/avatar4.jpg',
  ];

  final List<String> motherAvatars = const [
    'assets/images/mother/avatar1.jpg',
    'assets/images/mother/avatar2.jpg',
    'assets/images/mother/avatar3.jpg',
    'assets/images/mother/avatar4.jpg',
  ];

  List<String> currentAvatars = [];

  int selectedAvatarIndex = 1;
  String? selectedGender;

// controllers
final FormControllers controllers = FormControllers();


  @override
  void initState() {
    super.initState();
    // Default to father avatars
    currentAvatars = fatherAvatars;
  }

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
      selectedAvatarIndex = 0; // reset avatar selection
      if (gender == 'male') {
        currentAvatars = fatherAvatars;
      } else {
        currentAvatars = motherAvatars;
      }
    });
    debugPrint('Selected gender: $gender');
  }

  void _onAvatarSelected(int index) {
    setState(() {
      selectedAvatarIndex = index;
    });
    debugPrint('Selected avatar: ${currentAvatars[index]}');
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
            ),

            const SizedBox(height: 20),

            // Gender selector
            GenderSelector(
               controller: controllers.gender, // <- bind the controller
              onGenderSelected: _onGenderSelected,
            ),

            const SizedBox(height: 30),

           

            // TODO: Add signup form fields here
          ],
        ),
      ),
    );
  }
}
