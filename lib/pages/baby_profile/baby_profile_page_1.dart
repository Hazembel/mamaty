import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_top_bar_bebe_profile.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../../models/baby.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_create_bebe.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_alert_modal.dart';
import '../../pages/edit_baby_profile/edit_baby_profile_flow_page.dart';
import '../../providers/baby_provider.dart';
import '../../services/baby_service.dart';
import '../../widgets/app_snak_bar.dart';

class BabyProfilePage1 extends StatefulWidget {
  final VoidCallback onNext;
  final Baby babyProfileData;

  const BabyProfilePage1({
    super.key,
    required this.onNext,
    required this.babyProfileData,
  });

  @override
  State<BabyProfilePage1> createState() => _BabyProfilePage1State();
}

class _BabyProfilePage1State extends State<BabyProfilePage1> {
  bool _isEditMode = false;

  void _handleBabyTap(BuildContext context, Baby baby) {
    final babyProvider = context.read<BabyProvider>();

    if (_isEditMode) {
      EditBabyProfileFlow.start(context, baby);
      return;
    }

    babyProvider.selectBaby(baby);

    if (baby.autorisation == false) {
      CustomAlertModal.show(
        context,
        title: "Attention médicale requise",
        message:
            "Le profil de ${baby.name ?? 'le bébé'} indique une maladie ou allergie nécessitant une autorisation spéciale.",
        primaryText: "Consulter",
        secondaryText: "Modifier",
        onPrimary: () => Navigator.of(context).pushNamed('/doctors'),
        onSecondary: () => EditBabyProfileFlow.start(context, baby),
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }

  // 🔥 Skeleton Loader Grid
  Widget _buildSkeletonGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemSize = (constraints.maxWidth - 16) / 2;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: List.generate(4, (index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final babyProvider = context.watch<BabyProvider>();
    final babies = babyProvider.babies;

    // PRE-GET provider BEFORE async gap
    final babyProv = Provider.of<BabyProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppDimensions.padding40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppProfileBebe(
              onEdit: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              onLogout: () async {
       
                await userProvider.logout();

                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
                         babyProv.clear(); // safe clear
              },
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'Continuer ou créer vers son bébé',
                textAlign: TextAlign.center,
                style: AppTextStyles.inter24Bold.copyWith(
                  color: AppColors.premier,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // 🔥 If loading → show skeleton shimmer
            if (babyProvider.isLoading) _buildSkeletonGrid()

            // 🔥 If NOT loading → show real grid
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemSize = (constraints.maxWidth - 16) / 2;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        ...babies.map(
                          (baby) => SizedBox(
                            width: itemSize,
                            height: itemSize,
                            child: AvatarTile(
                              imagePath: baby.avatar ?? '',
                              size: itemSize,
                              showEditButtons: _isEditMode,
                              onTap: () => _handleBabyTap(context, baby),
                              onEdit: () =>
                                  EditBabyProfileFlow.start(context, baby),
                              onDelete: () {
                                CustomAlertModal.show(
                                  context,
                                  title: 'Supprimer bébé',
                                  message:
                                      'Voulez-vous vraiment supprimer ${baby.name} ?',
                                  primaryText: 'Oui',
                                  secondaryText: 'Non',
                                  onPrimary: () async {
                                    try {
                                      await BabyService.deleteBaby(baby.id!);
                                      babyProv.removeBaby(baby.id!);
                                      await userProvider
                                          .removeBabyFromUser(baby.id!);

                                      if (context.mounted) {
                                        AppSnackBar.show(
                                          context,
                                          message:
                                              '${baby.name} a été supprimé avec succès',
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        AppSnackBar.show(
                                          context,
                                          message:
                                              'Erreur lors de la suppression de ${baby.name}.',
                                        );
                                      }
                                    }
                                  },
                                  onSecondary: () async {},
                                );
                              },
                            ),
                          ),
                        ),

                        // Create new baby tile
                        SizedBox(
                          width: itemSize,
                          height: itemSize,
                          child: AppCreateBebe(
                            onTap: widget.onNext,
                            size: itemSize,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
