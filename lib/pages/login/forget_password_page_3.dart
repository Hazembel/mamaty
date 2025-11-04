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
    final password = controllers.passwordController.text;
    final confirmPassword = controllers.confirmPasswordController.text;

    setState(() {
      passwordError = controllers.validatePassword(password);
      confirmPasswordError = controllers.validateConfirmPassword(confirmPassword);
    });

    if (passwordError == null && confirmPasswordError == null) {
      _createPassword();
    } else {
      debugPrint('❌ Password validation failed');
    }
  }

  Future<void> _createPassword() async {
    final password = controllers.passwordController.text.trim();
    final phone = widget.forgetData.phone?.trim();

    if (phone == null || phone.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur : numéro de téléphone manquant')),
        );
      }
      return;
    }

    if (password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final success = await _authService.forgetPassword(phone, password);

      if (!mounted) return;

      if (success) {
        // Optionally save the password (usually not needed after reset)
        widget.forgetData.password = password;

        debugPrint('✅ Mot de passe mis à jour avec succès pour $phone');
        widget.onFinish();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Échec : utilisateur non trouvé ou erreur serveur')),
        );
      }
    } catch (e) {
      debugPrint('❌ Exception lors de la réinitialisation du mot de passe: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill if already entered (e.g., during back navigation)
    final savedPass = widget.forgetData.password;
    if (savedPass != null) {
      controllers.passwordController.text = savedPass;
      controllers.confirmPasswordController.text = savedPass;
    }
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
                onPressed: _isLoading ? null : _validateAndContinue,
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