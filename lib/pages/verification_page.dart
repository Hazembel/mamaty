import 'package:flutter/material.dart';
import '../widgets/app_code_input.dart';
import '../widgets/app_button.dart';
import '../widgets/app_top_bar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/dimensions.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;

  const VerificationPage({super.key, required this.phoneNumber});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
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

    // TODO: Implement actual verification logic
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      // TODO: Navigate to next screen on success
      debugPrint('Code verified: $_code');
    }
  }

  void _resendCode() {
    // TODO: Implement resend code logic
    debugPrint('Resending code to ${widget.phoneNumber}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          
          padding:  AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppTopBar(),
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
                      text: widget.phoneNumber,
                      style: AppTextStyles.inter14Med.copyWith(
                        color: AppColors.black, // Different color for phone
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppCodeInput(length: 4, onCompleted: _onCodeComplete),
              const SizedBox(height: 32),
              AppButton(
                title: 'Vérifier',
                onPressed: _code?.length == 4 && !_isLoading
                    ? _verifyCode
                    : null,
                size: ButtonSize.lg,
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: Text(
                    'Vous n\'avez pas reçu le code ? Renvoyer !',
                    style: AppTextStyles.inter14Med.copyWith(
                      //TODO: know the withvalues to oppacity 
                      color: AppColors.premier.withValues(alpha: 0.5),
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
