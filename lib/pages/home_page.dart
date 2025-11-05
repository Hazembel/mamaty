import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/advice_provider.dart';
import '../../widgets/home_header_card.dart';
import '../widgets/app_advise_picker.dart';
import '../../theme/dimensions.dart';
import '../../providers/baby_provider.dart';
import '../pages/baby_profile/baby_profile_page_1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _babyAgeInDays;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateBabyAgeAndAdvices();
    });
  }

  /// Calculate age in days and load advices from provider
  void _updateBabyAgeAndAdvices() {
    final babyProvider = context.read<BabyProvider>();
    final adviceProvider = context.read<AdviceProvider>();
    final baby = babyProvider.selectedBaby;

    if (baby != null && baby.birthday != null && baby.birthday!.isNotEmpty) {
      _babyAgeInDays = _calculateBabyAgeInDays(baby.birthday!);

      // Load advices for this baby and age
      adviceProvider.loadAdvices(
        babyId: baby.id!,
        ageInDays: _babyAgeInDays!,
      );
    } else {
      _babyAgeInDays = null;
    }
  }

  /// Helper: calculate age in days from birthday string
int _calculateBabyAgeInDays(String? birthday) {
    if (birthday == null || birthday.isEmpty) return 0;

    DateTime? birthDate;

    // Try ISO first (yyyy-MM-dd)
    birthDate = DateTime.tryParse(birthday);

    // Try dd/MM/yyyy manually if needed
    if (birthDate == null && birthday.contains('/')) {
      try {
        final parts = birthday.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          birthDate = DateTime(year, month, day);
        }
      } catch (e) {
        debugPrint('⚠️ Failed to parse birthday: $e');
        return 0;
      }
    }

    if (birthDate == null) return 0;

    final ageInDays = DateTime.now().difference(birthDate).inDays;
    return ageInDays < 0 ? 0 : ageInDays;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final babyProvider = context.watch<BabyProvider>();
    final adviceProvider = context.watch<AdviceProvider>();

    final user = userProvider.user;
    final userName = user?.name ?? 'Utilisateur';
    final userAvatar = user?.avatar;
    final babyProfileData = babyProvider.selectedBaby;
    final advices = adviceProvider.advices;

    return Scaffold(
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  if (babyProfileData != null)
                    HomeHeaderCard(
                      baby: babyProfileData,
                      userName: userName,
                      userAvatar: userAvatar,
                      onBabyTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => BabyProfilePage1(
                              onNext: () {},
                              babyProfileData: babyProfileData,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      onUserTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                    )
                  else
                    _noBabyCard(),

                  const SizedBox(height: 20),

                  // Advices Section with skeleton
                  _babyAgeInDays == null
                      ? const Center(
                          child: Text(
                            'Ajoutez un profil bébé pour voir les conseils.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : adviceProvider.isLoading
                          ? _buildAdvicesSkeleton()
                          : advices.isNotEmpty
                              ? BabyDayPicker(
                                  advices: advices,
                                  babyAgeInDays: _babyAgeInDays!,
                                )
                              : const Center(
                                  child: Text(
                                    'Aucun conseil disponible pour cet âge.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  /// Skeleton placeholder for advices
  Widget _buildAdvicesSkeleton() {
    return Column(
      children: [
        // Card placeholder
        Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 20),
        // Horizontal day placeholders
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (i) {
              return Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _noBabyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Aucun profil bébé trouvé',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
