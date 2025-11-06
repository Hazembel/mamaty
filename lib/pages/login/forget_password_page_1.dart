import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/app_text_field_phone.dart';
import '../../widgets/app_button.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../controllers/form_controllers.dart';
import '../../services/auth_service.dart';
import '../../theme/dimensions.dart';
import '../../models/forgetpassword_data.dart';
import '../../widgets/app_snak_bar.dart';
 

class ForgetPasswordPage1 extends StatefulWidget {
  final ForgetpasswordData forgetData;
  final VoidCallback onNext;

  const ForgetPasswordPage1({
    super.key,
    required this.forgetData,
    required this.onNext,
  });

  @override
  State<ForgetPasswordPage1> createState() => _ForgetPasswordPage1State();
}

class _ForgetPasswordPage1State extends State<ForgetPasswordPage1> {
  final FormControllers controllers = FormControllers();
  final AuthService _authService = AuthService();

  String? phoneError;
  bool isLoading = false;

 Future<void> _verifyPhone() async {
  setState(() {
    phoneError = controllers.validatePhone(controllers.phoneController.text);
  });

  if (phoneError != null) return;

  setState(() => isLoading = true);

  final phone = controllers.phoneController.text.trim();
  widget.forgetData.phone = phone; // Save phone to shared data

  try {
    final success = await _authService.requestOtp(phone);

    if (!mounted) return;

if (success) {
  AppSnackBar.show(
    context,
    message: '✅ Code envoyé sur $phone',
  );
  widget.onNext(); // Go to OTP input screen
} else {
  AppSnackBar.show(
    context,
    message: '⚠️ Ce numéro n\'existe pas',
   
  );
}

  } catch (e) {
    if (mounted) {
      debugPrint('❌ OTP request error: $e');
    }
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}
  @override
  void initState() {
    super.initState();
    controllers.phoneController.text = widget.forgetData.phone ?? '';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(),
            const SizedBox(height: 30),
            Text(
              'Vérification du numéro',
              style: AppTextStyles.inter24Bold.copyWith(
                color: AppColors.premier,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              'Entrez votre numéro de téléphone pour recevoir un code de confirmation par SMS.',
              style: AppTextStyles.inter14Reg.copyWith(
                color: AppColors.lightPremier,
              ),
            ),
            const SizedBox(height: 30),
            AppTextFieldPhone(
              controller: controllers.phoneController,
              errorText: phoneError,
            ),
            const SizedBox(height: 30),
            AppButton(
              title: 'Envoyer le code',
              size: ButtonSize.lg,
              onPressed: isLoading ? null : _verifyPhone,
              loading: isLoading,
              loadingText: 'Envoi du code...',
            ),
          ],
        ),
      ),
    );
  }
}
