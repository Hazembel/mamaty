import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_text_field_phone.dart';
import '../widgets/app_button.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../controllers/form_controllers.dart';
import '../services/auth_service.dart'; // ✅ add this import for API simulation
import 'verification_opt_page.dart';
import '../theme/dimensions.dart';
class VerificationNumeroPage extends StatefulWidget {
  const VerificationNumeroPage({super.key});

  @override
  State<VerificationNumeroPage> createState() => _VerificationNumeroPageState();
}

class _VerificationNumeroPageState extends State<VerificationNumeroPage> {
  final FormControllers controllers = FormControllers();
  final AuthService _authService = AuthService(); // ✅ instance of AuthService

  String? phoneError;
  bool isLoading = false;

  /// ✅ Function to verify phone number and simulate sending code
  Future<void> _verifyPhone() async {
    setState(() {
      phoneError = controllers.validatePhone(controllers.phoneController.text);
    });

    if (phoneError != null) return;

    setState(() => isLoading = true);

    final phone = controllers.phoneController.text.trim();

    try {
      final code = await _authService.loginVerifyPhoneNumber(phone);

      // ✅ Check if widget is still mounted before using context
      if (!mounted) return;

      if (code != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Code $code envoyé sur $phone')),
        );

      // ✅ Navigate to VerificationPage and pass the phone number
  if (mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationPage(phoneNumber: phone),
      ),
    );
  }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Ce numéro n\'existe pas')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding:  AppDimensions.pagePadding,
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
              title: isLoading ? 'Envoi...' : 'Connexion',
              size: ButtonSize.lg,
              onPressed: isLoading ? null : _verifyPhone,
            ),
          ],
        ),
      ),
    );
  }
}
