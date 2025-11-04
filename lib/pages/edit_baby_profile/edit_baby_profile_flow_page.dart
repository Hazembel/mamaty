import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/baby.dart'; 
import '../../services/baby_service.dart';

import 'edit_baby_profile_page_2.dart';
import 'edit_baby_profile_page_3.dart';
import 'edit_baby_profile_page_4.dart';
import 'edit_baby_profile_page_5.dart';
import 'edit_baby_profile_page_6.dart';
import 'edit_baby_profile_page_7.dart';
import '../../providers/baby_provider.dart';
import '../../theme/colors.dart';

class EditBabyProfileFlow extends StatefulWidget {
  final Baby baby;

  const EditBabyProfileFlow({super.key, required this.baby});

  static void start(BuildContext context, Baby baby) {
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
  late Baby babyData;

  @override
  void initState() {
    super.initState();
    // Copy initial baby object
    babyData = widget.baby;
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

Future<void> finishBebe() async {
  // Autorisation logic
  final hasCondition = (babyData.disease != null &&
          babyData.disease!.trim().toLowerCase() != 'aucune') ||
      (babyData.allergy != null &&
          babyData.allergy!.trim().toLowerCase() != 'aucune');

  babyData.autorisation = !hasCondition;

  debugPrint(hasCondition
      ? '🚫 Autorisation set to FALSE due to condition.'
      : '✅ Autorisation TRUE.');

  try {
    final babyProvider = context.read<BabyProvider>(); // ✅ use read instead of watch

    if (babyData.id == null || babyData.id!.isEmpty) {
      // Create new baby
      final savedBaby = await BabyService.addBaby(babyData);
      babyProvider.addBaby(savedBaby); // Add to provider

      debugPrint('🍼 Baby created successfully: ${savedBaby.id}');
    } else {
      // Update existing baby
      final updatedBaby =
          await BabyService.updateBaby(babyData.id!, babyData.toJson());
      babyProvider.updateBaby(updatedBaby); // Update provider

      debugPrint('💾 Baby updated successfully: ${updatedBaby.name}');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bébé enregistré avec succès'),
          backgroundColor: AppColors.premier,
        ),
      );
    }
  } catch (e) {
    debugPrint('❌ Failed to save or update baby: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }

  if (!mounted) return;
  Navigator.of(context).pop(babyData); // Return updated or created baby
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EditBabyProfilePage2(
            babyProfileData: babyData,
            onNext: nextPage,
            onBack: () => Navigator.pop(context),
          ),
          EditBabyProfilePage3(
            babyProfileData: babyData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage7(
            babyProfileData: babyData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage4(
            babyProfileData: babyData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage5(
            babyProfileData: babyData,
            onNext: nextPage,
            onBack: prevPage,
          ),
          EditBabyProfilePage6(
            babyProfileData: babyData,
            onNext: finishBebe,
            onBack: prevPage,
          ),
        ],
      ),
    );
  }
}
