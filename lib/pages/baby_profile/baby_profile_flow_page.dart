import 'package:flutter/material.dart';
import '../../models/baby_profile_data.dart';
import 'baby_profile_page_1.dart';
 
import 'package:shared_preferences/shared_preferences.dart';

class BabyProfileFlowPage extends StatefulWidget {
  const BabyProfileFlowPage({super.key});

  @override
  State<BabyProfileFlowPage> createState() => _BabyProfileFlowPageState();
}

class _BabyProfileFlowPageState extends State<BabyProfileFlowPage> {
  final PageController _pageController = PageController();
  final BabyProfileData babyData = BabyProfileData(); // shared data

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

  Future<void> finishProfile() async {
    // All data collected in babyData
    debugPrint('🎉 Baby profile completed:');
    debugPrint('Name: ${babyData.name}');
    debugPrint('Birthday: ${babyData.birthday}');
    debugPrint('Gender: ${babyData.gender}');
    debugPrint('Avatar: ${babyData.avatar}');

    // ✅ Save locally or to backend later
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_name', babyData.name ?? '');
    await prefs.setString('baby_avatar', babyData.avatar ?? '');
    await prefs.setString('baby_gender', babyData.gender ?? ''); 

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home'); // navigate to home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe
        children: [
          BabyProfilePage1(babyData: babyData, onNext: nextPage),
        
        ],
      ),
    );
  }
}
