// lib/controllers/form_controllers.dart
import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';
class FormControllers {
  // 📌 Controllers
   final TextEditingController nameController = TextEditingController();
   final TextEditingController lastnameController= TextEditingController();
   final TextEditingController emailController = TextEditingController();
   final TextEditingController phoneController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
   final TextEditingController confirmPasswordController = TextEditingController();
   final TextEditingController birthdayController = TextEditingController();
 
  // 📌 Validation Functions
// Validator for birthday (must be at least 18 years old)
  String? validateBirthday(String? dateText) {
    if (dateText == null || dateText.isEmpty) return 'Veuillez entrer votre date de naissance';

    try {
      final DateTime birthday = DateFormat('dd/MM/yyyy').parse(dateText);
      final DateTime today = DateTime.now();
      final age = today.year - birthday.year - ((today.month < birthday.month || (today.month == birthday.month && today.day < birthday.day)) ? 1 : 0);

      if (age < 18) return 'Vous devez avoir au moins 18 ans';
    } catch (e) {
      return 'Format de date invalide';
    }

    return null; // validr
  }
  /// Name: required
    String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    return null;
  }

  /// lastName: required
    String? validatelastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le prenom est requis';
    }
    return null;
  }

  /// Phone: required + 8 digits
   String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro est requis';
    }
    if (value.length != 8) {
      return 'Le numéro doit contenir 8 chiffres';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Le numéro ne doit contenir que des chiffres';
    }
    return null;
  }

  /// Email: required + valid + famous domains
   String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email est requis';
    }

    // Basic email regex
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }

    // Only allow famous domains
    final famousDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
    final domain = value.split('@').last.toLowerCase();
    if (!famousDomains.contains(domain)) {
      return 'Veuillez utiliser un email populaire (gmail, yahoo, etc.)';
    }

    return null;
  }

  /// Password: required + max 20 + must contain letter, number, symbol
   String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length > 20) {
      return 'Le mot de passe ne doit pas dépasser 20 caractères';
    }
    final letter = RegExp(r'[A-Za-z]');
    final number = RegExp(r'\d');
    final symbol = RegExp(r'[!@#\$&*~%^()_+=\[\]{}|\\;:,.<>/?-]');

    if (!letter.hasMatch(value) || !number.hasMatch(value) || !symbol.hasMatch(value)) {
      return 'Doit contenir une lettre, un chiffre et un symbole';
    }
    return null;
  }

  /// Confirm Password: must match password
   String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // 📌 Dispose all controllers
   void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthdayController.dispose();
        
  }
}
