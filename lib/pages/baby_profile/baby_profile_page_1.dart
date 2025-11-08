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
  bool _isEditMode = false; // toggles edit/delete icons

  @override
  void initState() {
    super.initState();
    // Initial load is now handled by UserProvider when user logs in
  }

  void _handleBabyTap(BuildContext context, Baby baby) {
    final babyProvider = context.read<BabyProvider>();

    if (_isEditMode) {
      // In edit mode, tap opens edit
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
        (Route<dynamic> route) => false, // removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final babyProvider = context.watch<BabyProvider>();
    final babies = babyProvider.babies;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: babyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppDimensions.padding40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppProfileBebe(
                    onEdit: () {
                      setState(() {
                        _isEditMode = !_isEditMode; // toggle edit mode
                      });
                    },
                    onLogout: () async {
                      await userProvider.logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacementNamed('/login');
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
                                        final babyProvider = context
                                            .read<BabyProvider>();
                                        final userProvider = context
                                            .read<UserProvider>();
                                        try {
                                          await BabyService.deleteBaby(
                                            baby.id!,
                                          );
                                          babyProvider.removeBaby(baby.id!);
                                          // Remove baby id from persisted user as well
                                          await userProvider.removeBabyFromUser(
                                            baby.id!,
                                          );
                                          if (context.mounted) {
                                        AppSnackBar.show(
  context,
  message: '${baby.name} a été supprimé avec succès',
);

                                          }
                                        } catch (e) {
                                          debugPrint(
                                            '❌ Failed to delete baby: $e',
                                          );
                                          if (context.mounted) {
                                            AppSnackBar.show(
                                              context,
                                              message:
                                                  'Une erreur est survenue lors de la suppression de ${baby.name}.',
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
                            // Add create button
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
