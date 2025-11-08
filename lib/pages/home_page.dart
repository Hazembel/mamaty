import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/user_provider.dart';
import '../../providers/advice_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/home_header_card.dart';
import '../widgets/app_advise_picker.dart';
import '../widgets/app_doctor_row.dart';
import '../widgets/app_recipe_row.dart';
import '../widgets/app_article_column.dart';
 
import '../../providers/baby_provider.dart';
import '../pages/baby_profile/baby_profile_flow_page.dart';
import '../providers/article_provider.dart';
import '../providers/doctor_provider.dart';
import '../../theme/dimensions.dart';

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

    // Ensure provider calls happen safely after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        await _updateBabyAgeAndAdvices();
        await _loadRecipesIfEligible();
        await _loadArticlesAndDoctors();
        setState(() {}); // rebuild UI after loading
      });
    });
  }

  /// 🔹 Safely update baby age & load advices
  Future<void> _updateBabyAgeAndAdvices() async {
    final babyProvider = context.read<BabyProvider>();
    final adviceProvider = context.read<AdviceProvider>();
    final baby = babyProvider.selectedBaby;

    if (baby != null && baby.birthday != null && baby.birthday!.isNotEmpty) {
      _babyAgeInDays = _calculateBabyAgeInDays(baby.birthday!);
      await adviceProvider.loadAdvices(
        babyId: baby.id!,
        ageInDays: _babyAgeInDays!,
      );
    } else {
      _babyAgeInDays = null;
    }
  }

  /// 🔹 Safely load recipes if baby age is eligible
  Future<void> _loadRecipesIfEligible() async {
    final babyProvider = context.read<BabyProvider>();
    final recipeProvider = context.read<RecipeProvider>();
    final baby = babyProvider.selectedBaby;

    if (baby != null && baby.birthday != null && baby.birthday!.isNotEmpty) {
      final ageInDays = _calculateBabyAgeInDays(baby.birthday!);
      if (ageInDays >= 271 && ageInDays <= 720) {
        await recipeProvider.loadRecipes(rating: 4.0);
      }
    }
  }

  /// 🔹 Safely load articles and doctors
  Future<void> _loadArticlesAndDoctors() async {
    final baby = context.read<BabyProvider>().selectedBaby;
    final babyId = baby?.id;
    final ageInDays = _babyAgeInDays ?? 0;

    await Future.wait([
      context.read<ArticleProvider>().loadArticles(
            ageInDays: ageInDays,
            babyId: babyId,
          ),
      context.read<DoctorProvider>().loadDoctors(),
    ]);
  }

  int _calculateBabyAgeInDays(String? birthday) {
    if (birthday == null || birthday.isEmpty) return 0;

    DateTime? birthDate = DateTime.tryParse(birthday);

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
          : RefreshIndicator(
              onRefresh: _refreshHomePage,
              child: SingleChildScrollView(
                 padding: AppDimensions.padding50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🍼 Header (Baby Profile or shimmer)
                    if (babyProfileData != null)
                      HomeHeaderCard(
                        baby: babyProfileData,
                        userName: userName,
                        userAvatar: userAvatar,
                        onBabyTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => BabyProfileFlowPage(
                           
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
                      _buildHomeHeaderSkeleton(),

                    const SizedBox(height: 20),

                    // 💡 Advices section
                    _babyAgeInDays == null
                        ? _buildAdvicesSkeleton()
                        : adviceProvider.isLoading
                            ? _buildAdvicesSkeleton()
                            : advices.isNotEmpty
                                ? BabyDayPicker(
                                    advices: advices,
                                    babyAgeInDays: _babyAgeInDays!,
                                  )
                                : _buildAdvicesSkeleton(),

                    const SizedBox(height: 20),

                    // 🍲 Recipes Section (only if baby age 271–720 days)
                    if (_babyAgeInDays != null &&
                        _babyAgeInDays! >= 271 &&
                        _babyAgeInDays! <= 720)
                      RecipeRow(),

                    const SizedBox(height: 20),

                    // 🩺 Doctors Section
                    const DoctorRow(),

                    const SizedBox(height: 20),

                    // 📰 Articles Section
                    const ArticleRow(),
                  ],
                ),
              ),
            ),
    );
  }

  /// 🔹 Pull-to-refresh logic
  Future<void> _refreshHomePage() async {
    // Safely reload all data
    await _updateBabyAgeAndAdvices();
    await _loadRecipesIfEligible();
    await _loadArticlesAndDoctors();

    // Rebuild UI
    if (mounted) setState(() {});
  }

  /// 💫 Shimmer skeleton matching HomeHeaderCard shape
  Widget _buildHomeHeaderSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),

            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 💫 Shimmer skeleton for advices
  Widget _buildAdvicesSkeleton() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (i) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
