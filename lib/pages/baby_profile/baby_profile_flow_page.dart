import 'package:flutter/material.dart';
import '../../models/baby_profile_data.dart';
import 'baby_profile_page_1.dart';
import 'baby_profile_page_2.dart';
import 'baby_profile_page_3.dart';
import 'baby_profile_page_4.dart';
import 'baby_profile_page_5.dart';
import 'baby_profile_page_6.dart';
import 'baby_profile_page_7.dart';

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

  void finishBebe() async {
    // At this point, all data is collected in babyProfileData
    final baby = babyProfileData; // assuming you have access to it here

    debugPrint('🎉 Baby completed with data:');
    debugPrint('✅ Name: ${baby.name}');
    debugPrint('✅ Birthday: ${baby.birthday}');
    debugPrint('✅ Gender: ${baby.gender}');
    debugPrint('✅ Avatar: ${baby.avatar}');
    debugPrint('✅ Weight: ${baby.weight}');
    debugPrint('✅ Disease: ${baby.disease}');
    debugPrint('✅ Allergy: ${baby.allergy}');
    debugPrint('✅ Head Size: ${baby.headSize}');
    debugPrint('✅ Parent Phone: ${baby.parentphone}');
    debugPrint('✅ Height: ${baby.height}');

  // ✅ Check allergy & disease
  final hasCondition = (baby.disease != null &&
          baby.disease!.trim().toLowerCase() != 'aucune') ||
      (baby.allergy != null &&
          baby.allergy!.trim().toLowerCase() != 'aucune');

  if (hasCondition) {
    baby.autorisation = false;
    debugPrint('🚫 Autorisation set to FALSE due to condition.');
/*
    try {
      // Call API to update autorisation
      await BabyService().updateAutorisation(baby.id!, false);
      debugPrint('✅ Autorisation updated on server.');
    } catch (e) {
      debugPrint('❌ Failed to update autorisation: $e');
    }*/
  } else {
    baby.autorisation = true;
    debugPrint('✅ Autorisation remains TRUE.');
  } 

    // ✅ Navigate safely
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/babyprofile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe
        children: [
          BabyProfilePage1(onNext: nextPage, babyProfileData: babyProfileData),

          BabyProfilePage2(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          BabyProfilePage3(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          BabyProfilePage7(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          BabyProfilePage4(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          BabyProfilePage5(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),

          BabyProfilePage6(
            babyProfileData: babyProfileData,
            onNext: finishBebe,
            onBack: prevPage,
          ),
        ],
      ),
    );
  }
}
