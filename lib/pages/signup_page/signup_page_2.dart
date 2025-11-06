import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../widgets/app_button.dart';
import '../../models/signup_data.dart'; // ✅ DATA

import '../../controllers/form_controllers.dart';
import '../../widgets/app_text_field_phone.dart';
import '../../widgets/app_text_field.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snak_bar.dart';
 
class SignupPage2 extends StatefulWidget {
  final SignupData signupData; // shared data
  final VoidCallback onNext; // go next
  final VoidCallback onBack; // go previous

  const SignupPage2({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final FormControllers controllers = FormControllers();
  final AuthService _authService = AuthService();

  String? nameError;
  String? lastnameError;
  String? emailError;
  String? phoneError;
  bool _isLoading = false;

  void _validateForm() {
    setState(() {
      nameError = controllers.validateName(controllers.nameController.text);
      lastnameError = controllers.validatelastName(controllers.lastnameController.text);
      emailError = controllers.validateEmail(controllers.emailController.text);
      phoneError = controllers.validatePhone(controllers.phoneController.text);
    });

    if ([nameError, lastnameError, emailError, phoneError].every((e) => e == null)) {
      _sendOtpAndContinue();
    } else {
      debugPrint('❌ Form has errors');
    }
  }

  Future<void> _sendOtpAndContinue() async {
    final phone = controllers.phoneController.text.trim();

    // Save valid data to shared object
    widget.signupData.name = controllers.nameController.text.trim();
    widget.signupData.lastname = controllers.lastnameController.text.trim();
    widget.signupData.email = controllers.emailController.text.trim();
    widget.signupData.phone = phone;

    setState(() => _isLoading = true);

    try {
      final success = await _authService.requestOtpSignup(phone);

      if (!mounted) return;

      if (success) {
        AppSnackBar.show(
  context,
  message: '✅ Code envoyé à $phone',
);

        widget.onNext(); // Go to OTP screen (SignupPage3)
      } else {
        AppSnackBar.show(
          context,
          message: '❌ Impossible de renvoyer le code',
        );
      }
    } catch (e) {
      debugPrint('❌ OTP request error: $e');
      
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controllers.nameController.text = widget.signupData.name ?? '';
    controllers.lastnameController.text = widget.signupData.lastname ?? '';
    controllers.emailController.text = widget.signupData.email ?? '';
    controllers.phoneController.text = widget.signupData.phone ?? '';
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
      body: SingleChildScrollView(
        padding: AppDimensions.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(onBack: widget.onBack),
            const SizedBox(height: 30),
            Text(
              'Compléter les données pour commencer',
              style: AppTextStyles.inter24Bold.copyWith(color: AppColors.premier),
            ),
            const SizedBox(height: 30),
            AppTextField(
              labelText: 'Quel est votre nom ?',
              controller: controllers.nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              labelText: 'Quel est votre prénom ?',
              controller: controllers.lastnameController,
              errorText: lastnameError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              labelText: 'Quelle est votre adresse e-mail ?',
              controller: controllers.emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 16),
            AppTextFieldPhone(
              controller: controllers.phoneController,
              errorText: phoneError,
            ),
            const SizedBox(height: 30),
            AppButton(
              title: 'Continuer',
              onPressed: _isLoading ? null : _validateForm,
              size: ButtonSize.lg,
              loading: _isLoading,
              loadingText: 'Envoi du code...',
            ),
          ],
        ),
      ),
    );
  }
}