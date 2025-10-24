import 'package:flutter/material.dart';
import '../../widgets/app_code_input.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/signup_data.dart';

class SignupPage3 extends StatefulWidget {
  final SignupData signupData; // ✅ shared signup data
  final VoidCallback onNext; // ✅ next step callback
  final VoidCallback onBack; // go previous

  const SignupPage3({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SignupPage3> createState() => _SignupPage3State();
}

class _SignupPage3State extends State<SignupPage3> {
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

    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // ✅ Save code (optional)
    widget.signupData.otpCode = _code;

    // Continue to next step
    debugPrint('✅ Code verified: $_code');
    widget.onNext();
  }

  void _resendCode() {
    // TODO: Implement resend code logic (API)
    debugPrint('🔁 Resending code to ${widget.signupData.phone ?? 'unknown'}');
  }

  // send code to phone number
  bool _isPressed = false;
  void _onTapDown(_) => setState(() => _isPressed = true);
  void _onTapUp(_) {
    setState(() => _isPressed = false);
    // RESEND CODE
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
                      text: widget.signupData.phone ?? '',
                      style: AppTextStyles.inter14Med.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 🧩 OTP input (disabled while verifying)
              IgnorePointer(
                ignoring: _isLoading,
                child: AppCodeInput(length: 4, onCompleted: _onCodeComplete),
              ),

              const SizedBox(height: 32),

              // 🧩 Animated verify button to prevent page blinking
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isLoading
                    ? const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(),
                      )
                    : AppButton(
                        key: const ValueKey('verifyBtn'),
                        title: 'Vérifier',
                        onPressed: _code?.length == 4 ? _verifyCode : null,
                        size: ButtonSize.lg,
                      ),
              ),

              const Spacer(),
              Align(
                //make the text animated when clicked
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
