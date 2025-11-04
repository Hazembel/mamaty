import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/baby.dart';
import '../../services/baby_service.dart';
import '../../providers/user_provider.dart'; // ✅ make sure this import exists
import '../../providers/baby_provider.dart'; // ✅ make sure this import exists
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

  // ✅ Baby object to collect all data progressively
  final Baby babyData = Baby(
    userId: '', // will be set before saving
  );

  bool _isSaving = false;

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

  Future<void> finishBebe() async {
    setState(() => _isSaving = true);

    try {
      // ✅ Get logged-in user
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?.id;

      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      // ✅ Attach userId
      babyData.userId = userId;

      // ✅ Autorisation based on disease/allergy
 final disease = (babyData.disease ?? '').trim().toLowerCase();
final allergy = (babyData.allergy ?? '').trim().toLowerCase();

final hasCondition = disease.isNotEmpty && disease != 'aucune' ||
                     allergy.isNotEmpty && allergy != 'aucune';

babyData.autorisation = !hasCondition;

debugPrint('Baby ID: "$disease", Allergy: "$allergy", Autorisation: ${babyData.autorisation}');


      if (hasCondition) {
        debugPrint('🚫 Autorisation set to FALSE due to medical condition.');
      } else {
        debugPrint('✅ Autorisation remains TRUE.');
      }

      // ✅ Call backend
      final savedBaby = await BabyService.addBaby(babyData);
      debugPrint('✅ Baby added successfully: ${savedBaby.toJson()}');
 
// ✅ Add the new baby to BabyProvider
if (!mounted) return;
final babyProvider = Provider.of<BabyProvider>(context, listen: false);
babyProvider.addBaby(savedBaby);

// ✅ Add the baby's ID to UserProvider
if (savedBaby.id != null) {
  userProvider.addBabyToUser(savedBaby.id!);
}


// ✅ Navigate to baby profile
Navigator.of(context).pushReplacementNamed('/babyprofile');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/babyprofile');
    } catch (e) {
      debugPrint('❌ Failed to save baby: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du bébé : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              BabyProfilePage1(onNext: nextPage, babyProfileData: babyData),
              BabyProfilePage2(
                babyProfileData: babyData,
                onNext: nextPage,
                onBack: prevPage,
              ),
              BabyProfilePage3(
                babyProfileData: babyData,
                onNext: nextPage,
                onBack: prevPage,
              ),
              BabyProfilePage7(
                babyProfileData: babyData,
                onNext: nextPage,
                onBack: prevPage,
              ),
              BabyProfilePage4(
                babyProfileData: babyData,
                onNext: nextPage,
                onBack: prevPage,
              ),
              BabyProfilePage5(
                babyProfileData: babyData,
                onNext: nextPage,
                onBack: prevPage,
              ),
              BabyProfilePage6(
                babyProfileData: babyData,
                onNext: finishBebe,
                onBack: prevPage,
              ),
            ],
          ),

          // ✅ Loading overlay
          if (_isSaving)
            Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
