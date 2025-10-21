import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_text_field_password.dart';
import '../widgets/app_top_bar.dart';
import '../theme/colors.dart';

import '../controllers/form_controllers.dart';
import '../widgets/app_text_field_date.dart';
import '../widgets/app_text_field_phone.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final FormControllers controllers = FormControllers();

  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  String? birthdayError;

  void _validateForm() {
      setState(() {
      // Use instance methods and controllers
      nameError = controllers.validateName(controllers.nameController.text);
      emailError = controllers.validateEmail(controllers.emailController.text);
      phoneError = controllers.validatePhone(controllers.phoneController.text);
      passwordError = controllers.validatePassword(controllers.passwordController.text);
      confirmPasswordError = controllers.validateConfirmPassword(controllers.confirmPasswordController.text);
      birthdayError = controllers.validateBirthday(controllers.birthdayController.text);
    });

    if ([
      nameError,
      emailError,
      phoneError,
      passwordError,
      confirmPasswordError,
      birthdayError,
    ].every((element) => element == null)) {
      debugPrint('✅ Form is valid!');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Formulaire valide 🎉')));
    } else {
      debugPrint('❌ Form has errors');
    }
  }

  @override
  void dispose() {
 controllers.dispose(); // disposes all static controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(),
            const SizedBox(height: 20),

            AppTextField(
              labelText: AppLocalizations.of(context)?.name ?? 'Nom',
              controller: controllers.nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 16),

            AppTextField(
              labelText: AppLocalizations.of(context)?.email ?? 'Email',
              controller: controllers.emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPhone(
              controller: controllers.phoneController,
              errorText: phoneError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPassword(
              labelText:
                  AppLocalizations.of(context)?.password ?? 'Mot de passe',
              controller: controllers.passwordController,
              errorText: passwordError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPassword(
              labelText:
                  AppLocalizations.of(context)?.confirmPassword ??
                  'Confirmer mot de passe',
              controller: controllers.confirmPasswordController,
              errorText: confirmPasswordError,
            ),
            const SizedBox(height: 16),

            AppTextFieldDate(
              labelText:
                  AppLocalizations.of(context)?.birthday ?? 'Date de naissance',
              controller: controllers.birthdayController,
              errorText: birthdayError,
            ),
            const SizedBox(height: 20),

            AppButton(
              title:
                  AppLocalizations.of(context)?.submitForm ??
                  'Valider le formulaire',
              onPressed: _validateForm,
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
