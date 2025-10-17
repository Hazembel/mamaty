// lib/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const premier = Color(0xFF0E6A74);
  static const lightPremier = Color.fromRGBO(14, 106, 116, 0.5); // 50% opacity
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF6F6F9);
  static const black = Color(0xFF000000);
  static const shadow = Color(0xFFF4F4F4);

  // Example shadow
  static const defaultShadow = BoxShadow(
    color: Color.fromRGBO(64, 64, 64, 0.15),
    offset: Offset(0, 8),
    blurRadius: 16,
    spreadRadius: 0,
  );
}
