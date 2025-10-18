import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_text_field_password.dart';
import '../widgets/app_top_bar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../controllers/form_controllers.dart';
import '../widgets/app_text_field_date.dart';
import '../widgets/app_text_field_phone.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  String? birthdayError;

  void _validateForm() {
    setState(() {
      nameError = FormControllers.validateName(
        FormControllers.nameController.text,
      );
      emailError = FormControllers.validateEmail(
        FormControllers.emailController.text,
      );
      phoneError = FormControllers.validatePhone(
        FormControllers.phoneController.text,
      );
      passwordError = FormControllers.validatePassword(
        FormControllers.passwordController.text,
      );
      confirmPasswordError = FormControllers.validateConfirmPassword(
        FormControllers.confirmPasswordController.text,
      );
      birthdayError = FormControllers().validateBirthday(
        FormControllers.birthdayController.text,
      ); // only birthday is non-static
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
    FormControllers.dispose(); // disposes all static controllers
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
              labelText: 'Nom',
              controller: FormControllers.nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 16),

            AppTextField(
              labelText: 'Email',
              controller: FormControllers.emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPhone(
              controller: FormControllers.phoneController,
              errorText: phoneError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPassword(
              labelText: 'Mot de passe',
              controller: FormControllers.passwordController,
              errorText: passwordError,
            ),
            const SizedBox(height: 16),

            AppTextFieldPassword(
              labelText: 'Confirmer mot de passe',
              controller: FormControllers.confirmPasswordController,
              errorText: confirmPasswordError,
            ),
            const SizedBox(height: 16),

            AppTextFieldDate(
              labelText: 'Date de naissance',
              controller: FormControllers.birthdayController,
              errorText: birthdayError,
            ),
            const SizedBox(height: 20),

            AppButton(
              title: 'Valider le formulaire',
              onPressed: _validateForm,
              size: ButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
