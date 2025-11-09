import 'package:flutter/material.dart';
import '../widgets/app_bar_profile.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/dimensions.dart';
import '../widgets/app_button.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _messageError;

  void _validateAndSubmit() {
    setState(() {
      // Reset errors
      _nameError = null;
      _emailError = null;
      _messageError = null;

      // Validate name
      if (_nameController.text.isEmpty) {
        _nameError = 'Le nom est requis';
      }

      // Validate email
      if (_emailController.text.isEmpty) {
        _emailError = 'L\'email est requis';
      } else if (!_isValidEmail(_emailController.text)) {
        _emailError = 'Email invalide';
      }

      // Validate message
      if (_messageController.text.isEmpty) {
        _messageError = 'Le message est requis';
      }

      // If no errors, submit
      if (_nameError == null && _emailError == null && _messageError == null) {
        _submitForm();
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _submitForm() {
    // TODO: Implement form submission
    debugPrint('Form submitted');
    debugPrint('Name: ${_nameController.text}');
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Message: ${_messageController.text}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppProfileBar(
              onBack: () => Navigator.of(context).pop(),
              topMargin: 40,
            ),
            Padding(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Contactez-nous',
                    style: AppTextStyles.inter24Bold.copyWith(
                      color: AppColors.premier,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nous sommes là pour vous aider',
                    style: AppTextStyles.inter14Med.copyWith(
                      color: AppColors.premier,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Nom',
                    errorText: _nameError,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _messageController,
                    labelText: 'Message',
                    maxLines: 5,
                    errorText: _messageError,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    title: 'Envoyer',
                    onPressed: _validateAndSubmit,
                    size: ButtonSize.lg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    int? maxLines,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      style: AppTextStyles.inter14Med.copyWith(color: AppColors.premier),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyles.inter14Med.copyWith(
          color: AppColors.lightPremier,
        ),
        errorText: errorText,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.premier, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
