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

class BabyProfilePage1 extends StatefulWidget {
  final VoidCallback onNext;

  const BabyProfilePage1({
    super.key,
    required this.onNext,
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
    // ✅ Load current user from SharedPreferences
    final UserData? userData = await _authService.loadUserData();
    if (userData != null) {
      setState(() {
        _babies = userData.babies;
      });
      debugPrint('Loaded babies: $_babies');
    } else {
      debugPrint('No user data found');
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
            // ✅ Step in top bar
            AppTopBar(
              showBack: false,
              currentStep: 1,
              totalSteps: 6,
            ),
            const SizedBox(height: 30),
            
            Center(
  child: Text(
    'Créez le profil de ton bébé',
    textAlign: TextAlign.center,
    style: AppTextStyles.inter24Bold.copyWith(
      color: AppColors.premier,
    ),
  ),
),
            const SizedBox(height: 60),

 
        // 🧩 Grid of existing babies + Add button
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30), // add left & right padding
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _babies.length + 1, // +1 for Add button
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      if (index < _babies.length) {
        final baby = _babies[index];
        return AvatarTile(
          imagePath: baby.avatar!,
          size: 120,
        );
      } else {
        // ✅ Add button
        return AppCreateBebe(
          onTap: () {
            widget.onNext(); // move to next page of flow
          },
        );
      }
    },
  ),
)

         
          ],

          
        ),
      ),
    );
  }
}
