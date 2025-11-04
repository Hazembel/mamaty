// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      // 1) Load persisted login data
      final loginData = await _authService.loadUser();

      // 2) Load persisted user data into the provider (reactive)
         if (!mounted) return;
      final userProvider = context.read<UserProvider>();
      await userProvider.loadUser();

      // debug prints for visibility
      if (userProvider.user != null) {
        debugPrint('Persisted user data on splash: ${userProvider.user}');
      } else {
        debugPrint('No persisted user data found');
      }

      // 3) Decide route: require both loginData and loaded user to consider logged in
      if (!mounted) return;
      if (loginData != null &&
          loginData.token != null &&
          loginData.token!.isNotEmpty &&
          userProvider.user != null) {
        Navigator.pushReplacementNamed(context, '/babyprofile');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e, st) {
      debugPrint('Splash init error: $e\n$st');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
