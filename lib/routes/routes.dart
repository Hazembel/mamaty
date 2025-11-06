import 'package:flutter/material.dart';
import '../pages/login/login_page.dart';
import '../pages/login/forgetpassword_flow_page.dart';
import '../pages/signup_page/signup_flow_page.dart';
import '../pages/splash_page.dart';
import '../pages/home_page.dart';
import '../pages/baby_profile/baby_profile_flow_page.dart';
import '../pages/doctors_page.dart';
import '../pages/recipe_page.dart';
// Public routes (accessible without login)
final Map<String, WidgetBuilder> publicRoutes = {
  '/': (context) => const SplashPage(), // ✅ SplashPage now the root
  '/login': (context) => const LoginPage(),
  '/forgetpassword': (context) => const ForgetPasswordFlowPage(),
  '/signup': (context) => const SignupFlowPage(),
};

// Private routes (for logged-in users)
final Map<String, WidgetBuilder> privateRoutes = {
  '/home': (context) => const HomePage(),
  
  '/doctors': (context) => const DoctorsPage(),

  '/recipes': (context) => const RecipesPage(),

  '/babyprofile': (context) => const BabyProfileFlowPage(),

};
