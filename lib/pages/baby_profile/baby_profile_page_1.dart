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
  List<Baby> _babyObjects = [];
  bool _isLoading = true;
  bool _isEditMode = false; // toggles edit/delete icons

  @override
  void initState() {
    super.initState();
    _loadBabies();
  }

  Future<void> _loadBabies() async {
    final userProvider = context.read<UserProvider>();
    final babyProvider = context.read<BabyProvider>();
    final babyIds = userProvider.user?.babies.toSet().toList() ?? [];

    debugPrint('🍼 Loading babies... $babyIds');

    if (babyIds.isEmpty) {
      setState(() {
        _babyObjects = [];
        _isLoading = false;
      });
      return;
    }

    try {
      await babyProvider.loadBabies(babyIds);
      if (!mounted) return;
      setState(() {
        _babyObjects = babyProvider.babies;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Failed to load babies: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppDimensions.pagePadding,
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
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: babies.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        if (index < babies.length) {
                          final baby = babies[index];
                          return AvatarTile(
                            imagePath: baby.avatar ?? '',
                            size: 150,
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
                                    // Call API to delete baby
                                    await BabyService.deleteBaby(baby.id!);

                                    // Remove baby locally
                                    babyProvider.removeBaby(baby.id!);
                                    userProvider.user?.babies.remove(baby.id!);

                                    // Update the local _babyObjects list and refresh UI
                                    setState(() {
                                      _babyObjects = babyProvider.babies;
                                    });

                                    // Show success message
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${baby.name} a été supprimé avec succès',
                                          ),
                                          backgroundColor: AppColors.premier,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint('❌ Failed to delete baby: $e');

                                    // Show error message
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Impossible de supprimer ${baby.name}',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  }
                                },
                                onSecondary: () {},
                              );
                            },
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
