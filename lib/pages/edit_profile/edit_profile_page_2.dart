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
  
 
class Editprofile2 extends StatefulWidget {
  final SignupData editProfileData; // shared data
  final VoidCallback onNext; // go next
  final VoidCallback onBack; // go previous

  const Editprofile2({
    super.key,
    required this.editProfileData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Editprofile2> createState() => _Editprofile2State();
}

class _Editprofile2State extends State<Editprofile2> {
  final FormControllers controllers = FormControllers();
  

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
    widget.editProfileData.name = controllers.nameController.text.trim();
    widget.editProfileData.lastname = controllers.lastnameController.text.trim();
    widget.editProfileData.email = controllers.emailController.text.trim();
    widget.editProfileData.phone = phone;

    setState(() => _isLoading = true);

    try {
    
      widget.onNext();
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
    controllers.nameController.text = widget.editProfileData.name ?? '';
    controllers.lastnameController.text = widget.editProfileData.lastname ?? '';
    controllers.emailController.text = widget.editProfileData.email ?? '';
    controllers.phoneController.text = widget.editProfileData.phone ?? '';
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