import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_text_field_password.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_top_bar.dart'; // 👈 import the top bar
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Remove default AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Custom top bar with back button
            const AppTopBar(),

            const SizedBox(height: 20),

            // Input field test
            const Text('Input Field', style: AppTextStyles.inter16SemiBold),
            const SizedBox(height: 8),
            const AppTextField(labelText: 'Quel est votre nom ?'),

            const SizedBox(height: 16),

            AppTextFieldPassword(
              labelText: 'Mot de passe',
              errorText: 'Le mot de passe est requis', // optional
            ),

            const SizedBox(height: 20),

            // Small Button
            const Text('Small Button', style: AppTextStyles.inter16SemiBold),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                title: 'Small Button',
                size: ButtonSize.sm,
                fullWidth: false,
                onPressed: () {
                  debugPrint('Small button pressed');
                },
              ),
            ),

            const SizedBox(height: 20),

            // Medium Button
            const Text('Medium Button', style: AppTextStyles.inter16SemiBold),
            const SizedBox(height: 8),
            AppButton(
              title: 'Medium Button',
              size: ButtonSize.md,
              onPressed: () {
                debugPrint('Medium button pressed');
              },
            ),

            const SizedBox(height: 20),

            // Large Button
            const Text('Large Button', style: AppTextStyles.inter16SemiBold),
            const SizedBox(height: 8),
            AppButton(
              title: 'Large Button',
              size: ButtonSize.lg,
              onPressed: () {
                debugPrint('Large button pressed');
              },
            ),

            const SizedBox(height: 20),

            // Loading Button
            const Text('Loading Button', style: AppTextStyles.inter16SemiBold),
            const SizedBox(height: 8),
            const AppButton(
              title: 'Loading...',
              loading: true,
              size: ButtonSize.md,
            ),
          ],
        ),
      ),
    );
  }
}
