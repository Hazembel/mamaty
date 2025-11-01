import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart'; 
import '../../widgets/home_header_card.dart';
import '../widgets/app_advise_picker.dart';
 
import '../../theme/dimensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

 

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to provider
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final userName = user?.name ?? 'Utilisateur';
    final userAvatar = user?.avatar;
 
 // ✅ HERE: get the selected baby from provider
  final babyProfileData = userProvider.selectedBaby;
    return Scaffold(
      
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🧩 Header section (dynamic)
                  if (babyProfileData != null)
                    HomeHeaderCard(
                      baby: babyProfileData,
                      userName: userName,
                      userAvatar: userAvatar,
                    )
                  else
                    _noBabyCard(),

                  const SizedBox(height: 20),

   // ✅ Add the day picker below the header
            const BabyDayPicker(),

            const SizedBox(height: 20),

                  // 🔹 Placeholder for next widgets
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Widgets à venir ici...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// 👶 If user has no baby profiles
  Widget _noBabyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
