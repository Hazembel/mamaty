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

  void _updateBabyAgeAndAdvices() {
  
     final babyProvider = context.watch<BabyProvider>();
    final adviceProvider = context.read<AdviceProvider>();
    final baby = babyProvider.selectedBaby;

    if (baby != null && baby.birthday != null && baby.birthday!.isNotEmpty) {
      _babyAgeInDays = _calculateBabyAgeInDays(baby.birthday!);
      adviceProvider.loadAdvicesForAge(_babyAgeInDays!);
    } else {
      _babyAgeInDays = null;
    }
  }

  int _calculateBabyAgeInDays(String birthdayString) {
    try {
      final birthDate = DateTime.parse(birthdayString);
      final now = DateTime.now();
      return now.difference(birthDate).inDays;
    } catch (e) {
      debugPrint('⚠️ Invalid birthday format: $birthdayString');
      return 0;
    }
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
  (Route<dynamic> route) => false, // remove all previous routes
);

  },
  onUserTap: () {
    Navigator.of(context).pushNamed('/profile'); // or any user profile page
  },
)

                  else
                    _noBabyCard(),

                  const SizedBox(height: 20),

                  // Advices
                  if (adviceProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (advices.isNotEmpty && _babyAgeInDays != null)
                    BabyDayPicker(
                      advices: advices,
                      babyAgeInDays: _babyAgeInDays!,
                    )
                  else
                    const Center(
                      child: Text(
                        'Ajoutez un profil bébé pour voir les conseils.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _noBabyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 3),
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
