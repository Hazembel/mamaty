import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_text_field_password.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/app_button.dart';
import '../services/auth_service.dart';
import '../theme/dimensions.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _phoneError;
  String? _passwordError;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    final user = await AuthService().login(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    // ✅ Check if widget still exists before using context or setState
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      _passwordError = null;
      // Success: show welcome or navigate
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bienvenue, ${user.name}!')));
    } else {
      setState(() {
        _passwordError = 'Numéro ou mot de passe incorrect';
      });
    }
  }

// forgot password button
  bool _isPressed = false;
  void _onTapDown(_) => setState(() => _isPressed = true);
  void _onTapUp(_) {
    setState(() => _isPressed = false);
    // Navigate after tap
    Navigator.pushNamed(context, '/verify-number');
  }

  void _onTapCancel() => setState(() => _isPressed = false);

// signup button
  bool _isPressedsignup = false;
  void _onTapDownsignup(_) => setState(() => _isPressedsignup = true);
  void _onTapUpsignup(_) {
    setState(() => _isPressedsignup = false);
    // Navigate after tap
    Navigator.pushNamed(context, '/signup');
  }

  void _onTapCancelsignup() => setState(() => _isPressedsignup = false);

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
              const SizedBox(height: 90),
              Text(
                'Bon retour ! Au plaisir de vous revoir !',
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              AppTextField(
                labelText: 'Quel est votre numéro de téléphone ?',
                controller: _phoneController,
                errorText: _phoneError,
              ),
              const SizedBox(height: 12),
              AppTextFieldPassword(
                labelText: 'Quelle est votre mot de passe ?',
                controller: _passwordController,
                errorText: _passwordError,
              ),
              const SizedBox(height: 8),
              Align(
                //make the text animated when clicked
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 100),
                    style: AppTextStyles.inter14Med.copyWith(
                      color: AppColors.black,
                      fontWeight: _isPressed
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    child: const Text('Mot de passe oublié?'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              AppButton(
                title: 'Connexion',
                onPressed: _isLoading ? null : _login,
                size: ButtonSize.lg,
              ),
              const Spacer(),
              Align(
                //make the text animated when clicked
                alignment: Alignment.center,
                child: GestureDetector(
                  onTapDown: _onTapDownsignup,
                  onTapUp: _onTapUpsignup,
                  onTapCancel: _onTapCancelsignup,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 100),
                    style: AppTextStyles.inter14Med.copyWith(
                      color: AppColors.black,
                      fontWeight: _isPressedsignup
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    child: const Text('Pas de compte ? S\'inscrire'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
