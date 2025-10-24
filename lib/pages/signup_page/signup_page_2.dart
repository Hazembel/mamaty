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
  ///
  final FormControllers controllers = FormControllers();
final AuthService _authService = AuthService(); //  ✅ API simulation
  String? nameError;
  String? lastnameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  String? birthdayError;
bool _isLoading = false;
  void _validateForm() {
    setState(() {
      // Use instance methods and controllers
      nameError = controllers.validateName(controllers.nameController.text);
      lastnameError = controllers.validatelastName(
        controllers.lastnameController.text,
      );
      emailError = controllers.validateEmail(controllers.emailController.text);
      phoneError = controllers.validatePhone(controllers.phoneController.text);
    });

    if ([
      nameError,
      emailError,
      phoneError,
      lastnameError,
    ].every((element) => element == null)) {
      debugPrint('✅ Form is valid!');

      // Save the birthday into shared signupData
      widget.signupData.name = controllers.nameController.text;
      widget.signupData.lastname = controllers.lastnameController.text;
      widget.signupData.email = controllers.emailController.text;
      widget.signupData.phone = controllers.phoneController.text;

 // ✅ Call backend simulation
  _verifyPhoneAndContinue();
  
    } else {
      debugPrint('❌ Form has errors');
    }
  }

//verification phone number and send otp code 

Future<void> _verifyPhoneAndContinue() async {
  final phone = controllers.phoneController.text.trim();

 setState(() {
      _isLoading = true;
    });

  final code = await _authService.signupVerifyPhoneSendCode(phone);

  if (!mounted) return;
 setState(() {
      _isLoading = false;
    });
  if (code != null) {
    debugPrint('✅ Code reçu: $code');
  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Code $code envoyé sur $phone')),
        );
    // Pass phone to SignupPage3 (OTP)
    widget.signupData.otpCode = code;

    widget.onNext(); // move to Signup3
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ce numéro est déjà enregistré ❌')),
    );
  }
}









// 🧩 Pre-fill fields when going back
@override
void initState() {
  super.initState();

  // ✅ Pre-fill controllers with saved data if available
  controllers.nameController.text = widget.signupData.name ?? '';
  controllers.lastnameController.text = widget.signupData.lastname ?? '';
  controllers.emailController.text = widget.signupData.email ?? '';
  controllers.phoneController.text = widget.signupData.phone ?? '';
}

  @override
  void dispose() {
    controllers.dispose(); // disposes all static controllers
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
              style: AppTextStyles.inter24Bold.copyWith(
                color: AppColors.premier,
              ),
            ),

            const SizedBox(height: 30),

            AppTextField(
              labelText: 'Quel est votre nom  ?',
              controller: controllers.nameController,
              errorText: nameError,
            ),

 const SizedBox(height: 16),

            AppTextField(
              labelText: 'Quel est votre prénom  ?',
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
            const SizedBox(height: 16),

            // Buttons
            const SizedBox(height: 30),

            AppButton(
              title: 'Continuer',
              onPressed: _validateForm,
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
