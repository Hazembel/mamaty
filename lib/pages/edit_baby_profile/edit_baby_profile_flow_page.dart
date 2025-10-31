import 'package:flutter/material.dart';
import '../../models/baby_profile_data.dart';

import 'edit_baby_profile_page_2.dart';
import 'edit_baby_profile_page_3.dart';
import 'edit_baby_profile_page_4.dart';
import 'edit_baby_profile_page_5.dart';
import 'edit_baby_profile_page_6.dart';
import 'edit_baby_profile_page_7.dart';

class EditBabyProfileFlow extends StatefulWidget {
  final BabyProfileData baby;

  const EditBabyProfileFlow({super.key, required this.baby});

  static void start(BuildContext context, BabyProfileData baby) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditBabyProfileFlow(baby: baby),
      ),
    );
  }

  @override
  State<EditBabyProfileFlow> createState() => _EditBabyProfileFlowState();
}

class _EditBabyProfileFlowState extends State<EditBabyProfileFlow> {
  final PageController _pageController = PageController();
  late BabyProfileData babyProfileData;

  @override
  void initState() {
    super.initState();
    // 🍼 Copy existing baby data into the form
    babyProfileData = BabyProfileData(
      name: widget.baby.name,
      birthday: widget.baby.birthday,
      gender: widget.baby.gender,
      avatar: widget.baby.avatar,
      parentphone: widget.baby.parentphone,
      height: widget.baby.height,
      weight: widget.baby.weight,
      disease: widget.baby.disease,
      allergy: widget.baby.allergy,
      headSize: widget.baby.headSize,
      autorisation: widget.baby.autorisation,
    );
  }

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
    final baby = babyProfileData;

    debugPrint('💾 Baby profile updated:');
    debugPrint('👶 Name: ${baby.name}');
    debugPrint('🎂 Birthday: ${baby.birthday}');
    debugPrint('🚻 Gender: ${baby.gender}');
    debugPrint('🖼️ Avatar: ${baby.avatar}');
    debugPrint('⚖️ Weight: ${baby.weight}');
    debugPrint('📏 Height: ${baby.height}');
    debugPrint('🧠 Head Size: ${baby.headSize}');
    debugPrint('💊 Disease: ${baby.disease}');
    debugPrint('🥜 Allergy: ${baby.allergy}');
    debugPrint('📞 Parent Phone: ${baby.parentphone}');
    debugPrint('🔐 Autorisation: ${baby.autorisation}');

    // ✅ Autorisation check logic
    final hasCondition = (baby.disease != null &&
            baby.disease!.trim().toLowerCase() != 'aucune') ||
        (baby.allergy != null &&
            baby.allergy!.trim().toLowerCase() != 'aucune');

    baby.autorisation = !hasCondition;

    debugPrint(hasCondition
        ? '🚫 Autorisation set to FALSE due to condition.'
        : '✅ Autorisation TRUE.');

    if (!mounted) return;
    Navigator.of(context).pop(baby); // ✅ Return updated baby
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EditBabyProfilePage2(
            babyProfileData: babyProfileData,
            onNext: nextPage,
        onBack: () => Navigator.pop(context), // only the first one exits
          ),
          EditBabyProfilePage3(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage7(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage4(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage5(
            babyProfileData: babyProfileData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage6(
            babyProfileData: babyProfileData,
            onNext: finishBebe,
            onBack: prevPage,
          ),
        ],
      ),
    );
  }
}
