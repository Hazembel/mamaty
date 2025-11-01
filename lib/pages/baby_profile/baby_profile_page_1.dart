import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_top_bar.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby_profile_data.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_create_bebe.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_alert_modal.dart';
import '../../pages/edit_baby_profile/edit_baby_profile_flow_page.dart';

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
 

  // ✅ Function to handle baby selection
void _handleBabyTap(BuildContext context, BabyProfileData baby) {
  final userProvider = context.read<UserProvider>();
  userProvider.selectBaby(baby); // ✅ set selected baby

  if (baby.autorisation == false) {
    CustomAlertModal.show(
      context,
      title: "Attention médicale requise",
      message:
          "Le profil de ${baby.name} indique une maladie ou allergie nécessitant une autorisation spéciale.",
      primaryText: "Consulter",
      secondaryText: "Modifier",
      onPrimary: () => Navigator.of(context).pushNamed('/doctors'),
      onSecondary: () => EditBabyProfileFlow.start(context, baby),
    );
  } else {
    Navigator.of(context).pushNamed('/home'); // ✅ home now shows selected baby
  }
}

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to provider
    final userProvider = context.watch<UserProvider>();
    final babies = userProvider.user?.babies ?? [];

    // ✅ Keep parent phone updated
    if (userProvider.user != null) {
      widget.babyProfileData.parentphone = userProvider.user!.phone;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppDimensions.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar(
              showBack: false,
              showLogout: true,
              onLogout: () async {
                
                await userProvider.logout(); // ✅ use provider
                  if (!context.mounted) return;
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
                itemCount: babies.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index < babies.length) {
                    final baby = babies[index];
                    return GestureDetector(
                      onTap: () => _handleBabyTap(context, baby),
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
