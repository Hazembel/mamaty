import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import 'signup_page_1.dart';
import 'signup_page_2.dart';
import 'signup_page_3.dart';

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
          // Add SignupPage3, SignupPage4 if needed
        ],
      ),
    );
  }
}
