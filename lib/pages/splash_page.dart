// lib/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';
import '../../providers/baby_provider.dart';
import '../theme/colors.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkLogin();
  }

  void _setupAnimation() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 

  Future<void> _checkLogin() async {
    try {

        // Wait for the splash animation to show
    await Future.delayed(const Duration(seconds: 2));
      final loginData = await _authService.loadUser();
      if (!mounted) return;

      final userProvider = context.read<UserProvider>();
      await userProvider.loadUser();

      if (loginData != null &&
          loginData.token != null &&
          loginData.token!.isNotEmpty &&
          userProvider.user != null) {
        if (!mounted) return;
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
   gradient: LinearGradient(
    colors: [
      AppColors.lightPremier,
      AppColors.premier,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: const Text(
              'Mamaty',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
