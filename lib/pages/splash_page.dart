// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';
import '../../providers/baby_provider.dart';

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
    final loginData = await _authService.loadUser();
    if (!mounted) return;
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUser();

    if (loginData != null &&
        loginData.token != null &&
        loginData.token!.isNotEmpty &&
        userProvider.user != null) {
      // ✅ Load babies before navigating
      final babyProvider = context.read<BabyProvider>();
      final babyIds = userProvider.user?.babies ?? [];
      debugPrint('🧾 user babyIds on splash: $babyIds');

      if (babyIds.isNotEmpty) {
        await babyProvider.loadBabies(babyIds);
        debugPrint('✅ Babies loaded on splash: ${babyProvider.babies.length}');
      } else {
        debugPrint('No baby IDs found for user');
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/babyprofile');
    } else {
      if (!mounted) return;
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
