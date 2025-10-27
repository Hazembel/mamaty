import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
 

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
    final loginData = await _authService.loadLoginData();
 

  // ✅ Load persisted user data
    final userData = await _authService.loadUserData();
    if (userData != null) {
      debugPrint('Persisted user data on splash: $userData');
    } else {
      debugPrint('No persisted user data found');
    }

    // ✅ Ensure widget is still mounted
    if (!mounted) return;




    if (loginData != null && loginData.token != null && loginData.token!.isNotEmpty) {
 
      Navigator.pushReplacementNamed(context, '/babyprofile');
    } else {
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
