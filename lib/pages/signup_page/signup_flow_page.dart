import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import 'signup_page_1.dart';
import 'signup_page_2.dart';
import 'signup_page_3.dart';
import 'signup_page_4.dart'; 
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';

class SignupFlowPage extends StatefulWidget {
  const SignupFlowPage({super.key});

  @override
  State<SignupFlowPage> createState() => _SignupFlowPageState();
}

class _SignupFlowPageState extends State<SignupFlowPage> {
  final PageController _pageController = PageController();
  final SignupData signupData = SignupData(); // shared data

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// Finish the signup process and save the collected data to SharedPreferences for auto-login.
  /// Print all collected data to the console for debugging.
  /// Navigate safely to the home page (/babyprofile).
void finishSignup() async {
  debugPrint('🎉 Signup completed with data:');
  debugPrint('Name: ${signupData.name}');
  debugPrint('Lastname: ${signupData.lastname}');
  debugPrint('Email: ${signupData.email}');
  debugPrint('Phone: ${signupData.phone}');
  debugPrint('Password: ${signupData.password}');
  debugPrint('Avatar: ${signupData.avatar}');
  debugPrint('Gender: ${signupData.gender}');
  debugPrint('Birthday: ${signupData.birthday}');

  final auth = AuthService();
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  // 1️⃣ Signup the user
  final newUser = await auth.signup(
    avatar: signupData.avatar,
    gender: signupData.gender,
    birthday: signupData.birthday,
    name: signupData.name ?? '',
    lastname: signupData.lastname ?? '',
    email: signupData.email ?? '',
    phone: signupData.phone ?? '',
    password: signupData.password ?? '',
  );

  if (newUser == null) {
      if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signup failed. Please try again.')),
    );
    return;
  }

  // 2️⃣ Immediately log in the user using the same credentials
  final loggedUser = await auth.login(
    phone: signupData.phone ?? '',
    password: signupData.password ?? '',
  );

  if (loggedUser != null) {
    userProvider.setUser(loggedUser);
    debugPrint('✅ Auto-login successful: ${loggedUser.name}');

    // 3️⃣ Navigate to baby profile
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/babyprofile');
  } else {
      if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login failed after signup')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // no swipe
        children: [
          SignupPage1(signupData: signupData, onNext: nextPage),
          SignupPage2( signupData: signupData, onNext: nextPage, onBack: prevPage),
          SignupPage3(signupData: signupData, onNext: nextPage, onBack: prevPage), 
           SignupPage4(signupData: signupData, onFinish: finishSignup, onBack: prevPage), 
          
          // Add SignupPage3, SignupPage4 if needed
        ],
      ),
    );
  }
}
