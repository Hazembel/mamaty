import 'package:flutter/material.dart';
import '../../models/forgetpassword_data.dart';
import 'forget_password_page_1.dart';
import 'forget_password_page_2.dart';
import 'forget_password_page_3.dart';
 

class ForgetPasswordFlowPage extends StatefulWidget {
  const ForgetPasswordFlowPage({super.key});

  @override
  State<ForgetPasswordFlowPage> createState() => _ForgetPasswordFlowPageState();
}

class _ForgetPasswordFlowPageState extends State<ForgetPasswordFlowPage> {
  final PageController _pageController = PageController();
  final ForgetpasswordData forgetData = ForgetpasswordData(); // shared data

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

  void finishFlow() {
    debugPrint('🎉 Forget password flow completed:');
    debugPrint('Phone: ${forgetData.phone}');
    debugPrint('OTP Code: ${forgetData.otpCode}');
    debugPrint('New Password: ${forgetData.password}'); 
 
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: [
          // Step 1: Enter Phone
          ForgetPasswordPage1(
            forgetData: forgetData,
            onNext: nextPage,
          ),

         ForgetPasswordPage2(
            forgetData: forgetData,
            onNext: nextPage,
            onBack: prevPage,
          ),

   ForgetPasswordPage3(
            forgetData: forgetData,
          
            onBack: prevPage, 
            onFinish:finishFlow
          ),

        ],
      ),
    );
  }
}
