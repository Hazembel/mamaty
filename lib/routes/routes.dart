import 'package:flutter/material.dart';

// Import all your pages here
import '../pages/login_page.dart';
import '../pages/verification_numero_page.dart';
import '../pages/signup_page.dart';
 
// You can later add protected (private) routes for logged-in users

final Map<String, WidgetBuilder> publicRoutes = {
  '/': (context) => const LoginPage(),
  '/verify-number': (context) => const VerificationNumeroPage(),
  '/signup': (context) => const SignupPage(),
  
};

// Example placeholder for future private routes
final Map<String, WidgetBuilder> privateRoutes = {
  // '/home': (context) => const HomePage(),
};

