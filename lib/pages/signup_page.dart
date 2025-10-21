import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_avatar.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final List<String> avatarImages = const [
    'assets/images/father/avatar1.png',
    'assets/images/father/avatar2.png',
    'assets/images/father/avatar3.png',
    'assets/images/father/avatar4.png',
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.32, // smaller fraction = items closer
      initialPage: (avatarImages.length / 2).floor(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTopBar(),

            const SizedBox(height: 30),

            Text(
              'Inscrivez-vous pour commencer',
              style: AppTextStyles.inter24Bold.copyWith(
                color: AppColors.premier,
              ),
            ),

            const SizedBox(height: 30),

            // Avatar scroller
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: avatarImages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 0;
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                      } else {
                        value = (_pageController.initialPage - index)
                            .toDouble();
                      }
                      value = value.abs();

                      final double scale = (1 - (value * 0.25)).clamp(
                       0.9,
                        1.0,
                      );

                      return Center(
                        child: SizedBox(
                          width: 120, // fixed width
                          height: 120, // fixed height → keeps square
                          child: Transform.scale(
                            scale: scale,
                            child: AvatarTile(imagePath: avatarImages[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // TODO: Add signup form fields here
          ],
        ),
      ),
    );
  }
}
