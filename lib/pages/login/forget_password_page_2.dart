import 'package:flutter/material.dart';
import '../../widgets/app_code_input.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/forgetpassword_data.dart';
import '../../services/auth_service.dart';

class ForgetPasswordPage2 extends StatefulWidget {
  final ForgetpasswordData forgetData; // ✅ shared data
  final VoidCallback onNext; // go next
  final VoidCallback onBack; // go back

  const ForgetPasswordPage2({
    super.key,
    required this.forgetData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ForgetPasswordPage2> createState() => _ForgetPasswordPage2State();
}

class _ForgetPasswordPage2State extends State<ForgetPasswordPage2> {
  String? _code;
  bool _isLoading = false;
  bool _isPressed = false;

  final AuthService _authService = AuthService();

  void _onCodeComplete(String code) {
    setState(() {
      _code = code;
    });
  }

  Future<void> _verifyCode() async {
    final code = _code;
    final phone = widget.forgetData.phone;

    if (code == null || code.length != 4 || phone == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await _authService.verifyOtp(phone, code);

      if (!mounted) return;

      if (isValid) {
        widget.forgetData.otpCode = code;
        debugPrint('✅ OTP verified successfully');
        widget.onNext();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Code OTP invalide')),
        );
      }
    } catch (e) {
      debugPrint('❌ OTP verification error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Échec de la vérification')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    final phone = widget.forgetData.phone;
    if (phone == null) return;

    // Prevent spamming during resend
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.requestOtp(phone);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Nouveau code envoyé à $phone')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Impossible de renvoyer le code')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Visual feedback only
  void _onTapDown(_) => setState(() => _isPressed = true);
  void _onTapUp(_) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

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
                'Vérification OTP',
                style: AppTextStyles.inter24Bold.copyWith(color: AppColors.premier),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Saisissez l\'OTP envoyé au ',
                      style: AppTextStyles.inter14Med.copyWith(color: AppColors.lightPremier),
                    ),
                    TextSpan(
                      text: widget.forgetData.phone ?? '',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              IgnorePointer(
                ignoring: _isLoading,
                child: AppCodeInput(
                  length: 4,
                  onCompleted: _onCodeComplete,
                ),
              ),
              const SizedBox(height: 32),

              AppButton(
                key: const ValueKey('verifyBtn'),
                title: 'Vérifier',
                onPressed: _isLoading || _code?.length != 4 ? null : _verifyCode,
                size: ButtonSize.lg,
                loading: _isLoading,
                loadingText: 'Vérifier...',
              ),

              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  onTap: _isLoading ? null : _resendCode, // ✅ Trigger action HERE
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 100),
                    style: AppTextStyles.inter14Med.copyWith(
                      color: _isLoading ? AppColors.lightPremier : AppColors.black,
                      fontWeight: _isPressed ? FontWeight.bold : FontWeight.w500,
                    ),
                    child: const Text('Vous n\'avez pas reçu le code ? Renvoyer !'),
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