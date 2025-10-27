import 'package:flutter/material.dart';
import '../../models/baby_profile_data.dart';
import 'baby_profile_page_1.dart';
import 'baby_profile_page_2.dart';
import 'baby_profile_page_3.dart';
 import 'baby_profile_page_4.dart';

class BabyProfileFlowPage extends StatefulWidget {
  const BabyProfileFlowPage({super.key});

  @override
  State<BabyProfileFlowPage> createState() => _BabyProfileFlowPageState();
}

class _BabyProfileFlowPageState extends State<BabyProfileFlowPage> {
  final PageController _pageController = PageController(); 
final BabyProfileData babyProfileData = BabyProfileData(); // shared data
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
  debugPrint('🎉 baby completed with data:'); 
 
  // ✅ Navigate safely
  if (!mounted) return;
  Navigator.of(context).pushReplacementNamed('/home'); // go to home
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe
        children: [
          BabyProfilePage1( 
            onNext: nextPage, 
          ),
         BabyProfilePage2( 
            babyProfileData: babyProfileData,
            onNext: nextPage, 
            onBack: prevPage ,
          ),
 BabyProfilePage3( 
            babyProfileData: babyProfileData,
            onNext: nextPage, 
            onBack: prevPage ,
          ),
 BabyProfilePage4( 
            babyProfileData: babyProfileData,
            onNext: nextPage, 
            onBack: prevPage ,
          ),

 


        ],
      ),
    );
  }
}
