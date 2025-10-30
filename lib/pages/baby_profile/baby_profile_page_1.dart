import 'package:flutter/material.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby_profile_data.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_create_bebe.dart';
import '../../services/auth_service.dart';
import '../../models/user_data.dart';
import '../../widgets/custom_alert_modal.dart';

class BabyProfilePage1 extends StatefulWidget {
  final VoidCallback onNext;
  final BabyProfileData babyProfileData;

  const BabyProfilePage1({
    super.key,
    required this.onNext,
    required this.babyProfileData,
  });

  @override
  State<BabyProfilePage1> createState() => _BabyProfilePage1State();
}

class _BabyProfilePage1State extends State<BabyProfilePage1> {
  List<BabyProfileData> _babies = [];
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadBabies();
  }

  Future<void> _loadBabies() async {
    final UserData? userData = await _authService.loadUserData();
    if (userData != null) {
      setState(() {
        _babies = userData.babies;
        widget.babyProfileData.parentphone = userData.phone;
      });
      debugPrint('Loaded babies: $_babies');
    } else {
      debugPrint('No user data found');
    }
  }

  // ✅ Function to handle baby selection
void _handleBabyTap(BuildContext context, BabyProfileData baby) {
  // 🧮 Calculate baby age (as before)
  try {
    final birthDate = DateTime.parse(baby.birthday ?? '');
    final now = DateTime.now();
    final ageInDays = now.difference(birthDate).inDays;
    final ageInMonths = (ageInDays / 30.44).floor();
    final ageInYears = (ageInDays / 365).floor();

    String ageDisplay;
    if (ageInDays < 30) {
      ageDisplay = '$ageInDays jours';
    } else if (ageInMonths < 12) {
      ageDisplay = '$ageInMonths mois';
    } else {
      final monthsAfterYear = ageInMonths % 12;
      ageDisplay = '$ageInYears an${ageInYears > 1 ? "s" : ""}'
          '${monthsAfterYear > 0 ? " et $monthsAfterYear mois" : ""}';
    }

    // 🩵 Debug prints
    debugPrint('👶 Bébé sélectionné: ${baby.name}');
    debugPrint('🍼 Âge: $ageDisplay');
    debugPrint('🚻 Genre: ${baby.gender}');
    debugPrint('⚖️ Poids: ${baby.weight}');
    debugPrint('📏 Taille: ${baby.height}');
    debugPrint('🧠 Tour de tête: ${baby.headSize}');
    debugPrint('💊 Maladie: ${baby.disease}');
    debugPrint('🥜 Allergie: ${baby.allergy}');
    debugPrint('📞 Téléphone parent: ${baby.parentphone}');
    debugPrint('🔐 Autorisation: ${baby.autorisation}');



    // 🚨 If baby has autorisation = false → show modal
    if (baby.autorisation == false) {
      debugPrint('🚨 DANGER: Ce bébé nécessite une autorisation médicale !');

      CustomAlertModal.show(
        context,
        title: "Attention médicale requise",
        message:
            "Le profil de ${baby.name} indique une maladie ou allergie nécessitant une autorisation spéciale.",
        primaryText: "Consulter",
        secondaryText: "Modifier",
        onPrimary: () {
           Navigator.of(context).pushReplacementNamed('/doctors');
          debugPrint('🩺 Consulter le dossier médical de ${baby.name}');
        },
        onSecondary: () {
          debugPrint('✏️ Modification de la maladie/allergie de ${baby.name}');
        },
      );
      return;
    }
    else {  Navigator.of(context).pushReplacementNamed('/home');}

    // ✅ Otherwise continue normal flow
    debugPrint('✅ Bébé autorisé, navigation normale...');
  } catch (e) {
    debugPrint('⚠️ Erreur lors du calcul de l’âge : $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppDimensions.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(
              showBack: false,
              currentStep: 1,
              totalSteps: 7,
showLogout: true,
  onLogout: () async {
    await AuthService().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  },

            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Continuer ou créer vers son bébé',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),
            const SizedBox(height: 60),

            // 🧩 Grid of babies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _babies.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index < _babies.length) {
                    final baby = _babies[index];
                    return GestureDetector(
                      onTap: () => _handleBabyTap(context,baby), // ✅ clean function call
                      child: AvatarTile(
                        imagePath: baby.avatar ?? '',
                        size: 120,
                      ),
                    );
                  } else {
                    return AppCreateBebe(onTap: widget.onNext);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
