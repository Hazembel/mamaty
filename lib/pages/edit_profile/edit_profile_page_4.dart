 import 'package:flutter/material.dart';
import '../../widgets/app_text_field_password.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/signup_data.dart';
import '../../controllers/form_controllers.dart';

class Editprofile4 extends StatefulWidget {
  final SignupData editProfileData; // ✅ shared signup data
 final VoidCallback onFinish;
  final VoidCallback onBack; // go previous

  const Editprofile4({
    super.key,
    required this.editProfileData,
    required this.onFinish,
    required this.onBack,
  });

  @override
  State<Editprofile4> createState() => _Editprofile4State();
}

class _Editprofile4State extends State<Editprofile4> {
  final FormControllers controllers = FormControllers();

  String? passwordError;
  String? confirmPasswordError;
  bool _isLoading = false;

  void _validateAndContinue() {
    setState(() {
      passwordError =
          controllers.validatePassword(controllers.passwordController.text);
    passwordError = controllers.validatePassword(controllers.passwordController.text);
      confirmPasswordError = controllers.validateConfirmPassword(controllers.confirmPasswordController.text);
    });

    if ([passwordError, confirmPasswordError].every((e) => e == null)) {
      debugPrint('✅ Passwords valid');

      // Save password to shared editProfileData
      widget.editProfileData.password = controllers.passwordController.text;

      _continue();
    } else {
      debugPrint('❌ Password errors');
    }
  }

  Future<void> _continue() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    debugPrint('✅ Password saved: ${widget.editProfileData.password}');
    widget.onFinish();
  }

  @override
  void initState() {
    super.initState();

    // Pre-fill password fields if previously entered
    controllers.passwordController.text = widget.editProfileData.password ?? '';
    controllers.confirmPasswordController.text = widget.editProfileData.password ?? '';
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTopBar(onBack: widget.onBack),
              const SizedBox(height: 30),
              Text(
                'Créer un mot de passe',
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre nouveau mot de passe doit être unique par rapport à ceux utilisés précédemment.',
                style: AppTextStyles.inter14Med.copyWith(
                  color: AppColors.lightPremier,
                ),
              ),
              const SizedBox(height: 32),

              AppTextFieldPassword(
                controller: controllers.passwordController,
                labelText: 'Mot de passe',
                errorText: passwordError,
              ),
              const SizedBox(height: 16),
              AppTextFieldPassword(
                controller: controllers.confirmPasswordController,
                labelText: 'Confirmer le mot de passe',
                errorText: confirmPasswordError,
              ),
              const SizedBox(height: 32),

              // Button with loading
              
                    AppButton(
                        key: const ValueKey('continueBtn'),
                        title: 'Continuer',
                        onPressed: _validateAndContinue,
                        size: ButtonSize.lg,
                        loading: _isLoading,
                      ),
              
            ],
          ),
        ),
      ),
    );
  }
}
