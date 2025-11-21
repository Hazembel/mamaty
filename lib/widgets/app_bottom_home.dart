import 'package:flutter/material.dart';
import '../pages/doctors_page.dart';
import '../pages/articles_page.dart';
import '../pages/recipe_page.dart';
import '../pages/favorite_page.dart';
import '../pages/edit_profile/edit_profile_flow_page.dart';
import '../models/signup_data.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/baby_provider.dart';
import '../../theme/colors.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key});

  void _navigate(BuildContext context, int index, List<_BarItem> items) {
    final user = context.read<UserProvider>().user;
    final item = items[index];

    switch (item.page) {
      case _BarPage.profile:
        if (user != null) {
          final signupData = SignupData()
            ..avatar = user.avatar
            ..gender = user.gender
            ..birthday = user.birthday
            ..name = user.name
            ..lastname = user.lastname
            ..phone = user.phone
            ..email = user.email
            ..password = '';

          EditprofileFlowPage.start(context, signupData);
        }
        break;
      case _BarPage.articles:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ArticlesPage()));
        break;
      case _BarPage.recipes:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecipesPage()));
        break;
      case _BarPage.doctors:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DoctorsPage()));
        break;
      case _BarPage.favorites:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritePage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final babyProvider = context.watch<BabyProvider>();
    final baby = babyProvider.selectedBaby;

    int? ageInDays;
    if (baby != null && baby.birthday != null && baby.birthday!.isNotEmpty) {
      final parts = baby.birthday!.contains('/')
          ? baby.birthday!.split('/')
          : baby.birthday!.split('-');
      if (parts.length == 3) {
        try {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          ageInDays = DateTime.now().difference(DateTime(year, month, day)).inDays;
        } catch (_) {}
      }
    }

    // Build the bar items dynamically
    final List<_BarItem> items = [
      _BarItem(icon: Icons.person, page: _BarPage.profile),
      _BarItem(icon: Icons.article, page: _BarPage.articles),
      // Only show recipes if baby age is eligible
      if (ageInDays != null && ageInDays >= 271 && ageInDays <= 720)
        _BarItem(icon: Icons.restaurant, page: _BarPage.recipes),
      _BarItem(icon: Icons.medical_services, page: _BarPage.doctors),
      _BarItem(icon: Icons.favorite, page: _BarPage.favorites),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.defaultShadow],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColors.lightPremier,
              onTap: () => _navigate(context, index, items),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  item.icon,
                  color: AppColors.premier,
                  size: 28,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BarItem {
  final IconData icon;
  final _BarPage page;

  _BarItem({required this.icon, required this.page});
}

enum _BarPage { profile, articles, recipes, doctors, favorites }
