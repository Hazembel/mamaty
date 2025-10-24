import 'package:flutter/material.dart';
import '../../widgets/app_code_input.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/forgetpassword_data.dart';

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

  void _onCodeComplete(String code) {
    setState(() {
      _code = code;
    });
  }

  Future<void> _verifyCode() async {
    if (_code == null || _code!.length != 4) return;

    setState(() {
      _isLoading = true;
    });

    // simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Save OTP code in ForgetpasswordData
    widget.forgetData.otpCode = _code;

    debugPrint('✅ Code verified: $_code');

    // Continue to next step
    widget.onNext();
  }

  void _resendCode() {
    debugPrint('🔁 Resending code to ${widget.forgetData.phone}');
  }

  bool _isPressed = false;
  void _onTapDown(_) => setState(() => _isPressed = true);
  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _resendCode();
  }

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
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Saisissez l\'OTP envoyé au ',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: AppColors.lightPremier,
                      ),
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
                onPressed: _code?.length == 4 ? _verifyCode : null,
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
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 100),
                    style: AppTextStyles.inter14Med.copyWith(
                      color: AppColors.black,
                      fontWeight: _isPressed
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    child: const Text(
                      'Vous n\'avez pas reçu le code ? Renvoyer !',
                    ),
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
