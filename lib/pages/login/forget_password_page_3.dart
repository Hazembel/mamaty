import 'package:flutter/material.dart';
import '../../widgets/app_text_field_password.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../controllers/form_controllers.dart';
import '../../services/auth_service.dart';
import '../../models/forgetpassword_data.dart';

class ForgetPasswordPage3 extends StatefulWidget {
  final ForgetpasswordData forgetData; // shared data
  final VoidCallback onFinish; // finish callback
  final VoidCallback onBack; // go previous

  const ForgetPasswordPage3({
    super.key,
    required this.forgetData,
    required this.onFinish,
    required this.onBack,
  });

  @override
  State<ForgetPasswordPage3> createState() => _ForgetPasswordPage3State();
}

class _ForgetPasswordPage3State extends State<ForgetPasswordPage3> {
  final FormControllers controllers = FormControllers();
  final AuthService _authService = AuthService();

  String? passwordError;
  String? confirmPasswordError;
  bool _isLoading = false;

  void _validateAndContinue() {
    setState(() {
      passwordError = controllers.validatePassword(
        controllers.passwordController.text,
      );
      confirmPasswordError = controllers.validateConfirmPassword(
        controllers.confirmPasswordController.text,
      );
    });

    if ([passwordError, confirmPasswordError].every((e) => e == null)) {
      _createPassword();
    } else {
      debugPrint('❌ Password validation failed');
    }
  }

  Future<void> _createPassword() async {
    setState(() => _isLoading = true);

    final password = controllers.passwordController.text;
    final phone = widget.forgetData.phone;

    if (phone == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : numéro manquant')),
      );
      return;
    }

    final success = await _authService.forgetPassCreatePassword(
      phone: phone,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Save password to shared forgetData
      widget.forgetData.password = password;

      debugPrint('✅ Password created for $phone');
      widget.onFinish(); // continue the flow
    } else {
      debugPrint('❌ Failed to create password (user not found)');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur : utilisateur introuvable')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // pre-fill password if previously entered
    controllers.passwordController.text = widget.forgetData.password ?? '';
    controllers.confirmPasswordController.text = widget.forgetData.password ?? '';
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
