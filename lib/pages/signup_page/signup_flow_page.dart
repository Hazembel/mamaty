import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import 'signup_page_1.dart';
import 'signup_page_2.dart';
import 'signup_page_3.dart';
import 'signup_page_4.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 
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

 void finishSignup() async {

  // At this point, all data is collected in signupData
  debugPrint('🎉 Signup completed with data:');
  debugPrint('Name: ${signupData.name}');
  debugPrint('Lastname: ${signupData.lastname}');
  debugPrint('Email: ${signupData.email}');
  debugPrint('Phone: ${signupData.phone}');
  debugPrint('Password: ${signupData.password}');
  debugPrint('Avatar: ${signupData.avatar}');
  debugPrint('Gender: ${signupData.gender}');
  debugPrint('Birthday: ${signupData.birthday}');
  debugPrint('OTP Code: ${signupData.otpCode}');

    // ✅ Save login token/data for auto-login
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('login_phone', signupData.phone ?? '');
  await prefs.setString('login_token', signupData.otpCode ?? ''); 
  // you can replace otpCode with a real token from backend later

  // ✅ Navigate safely
  if (!mounted) return;
  Navigator.of(context).pushReplacementNamed('/babyprofile'); // go to home
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
