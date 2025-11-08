import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // <-- Add shimmer package
import '../models/advice.dart';
import '../providers/user_provider.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_row_likedislike.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../services/advice_service.dart'; // voteAdvice
import '../widgets/app_snak_bar.dart';

class AdviceDetailPage extends StatefulWidget {
  final Advice advice;

  const AdviceDetailPage({super.key, required this.advice});

  @override
  State<AdviceDetailPage> createState() => _AdviceDetailPageState();
}

class _AdviceDetailPageState extends State<AdviceDetailPage> {
  late Advice _advice;
  bool _isLoading = true; // shimmer loading state

  @override
  void initState() {
    super.initState();
    _advice = widget.advice;

    // simulate loading delay for shimmer effect
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _vote(String type, String userId) async {
    try {
      final updatedAdvice = await AdviceService.voteAdvice(
        adviceId: _advice.id!,
        userId: userId,
        type: type,
      );
      setState(() {
        _advice.likes = updatedAdvice.likes;
        _advice.dislikes = updatedAdvice.dislikes;
      });

      if (!mounted) return;

      final message = type == 'like'
          ? "Vous avez aimé ce conseil 👍"
          : "Vous n'avez pas aimé ce conseil 👎";
      AppSnackBar.show(context, message: message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: "Impossible de voter pour le moment",
        backgroundColor: Colors.redAccent,
      );
    }
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 290, width: double.infinity, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 20, width: 200, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 14, width: 150, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 200, width: double.infinity, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: 15),
          Container(height: 50, width: double.infinity, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = userProvider.user?.id;

    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? Padding(
                padding: AppDimensions.pagePadding,
                child: _buildShimmer(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top image + AppTopBar (keep full width)
                  Stack(
                    children: [
                      if (_advice.imageUrl.isNotEmpty)
                        SizedBox(
                          height: 290,
                          width: double.infinity,
                          child: Image.network(
                            _advice.imageUrl.first,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 290,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      Padding(
                        padding: AppDimensions.pagePadding,
                        child: AppTopBar(
                        
                          showBack: true,
                          showLogout: false,
                          onBack: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),

                  // Everything else shares the same padding
                  Padding(
                    padding: AppDimensions.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          _advice.title,
                          style: AppTextStyles.inter16SemiBold.copyWith(
                            color: AppColors.premier,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Category & sources
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _advice.category,
                              style: AppTextStyles.inter12Med.copyWith(
                                color: AppColors.premier,
                              ),
                            ),
                            Text(
                              _advice.sources != null &&
                                      _advice.sources!.isNotEmpty
                                  ? _advice.sources!.join(' • ')
                                  : '',
                              style: AppTextStyles.inter12Med.copyWith(
                                color: AppColors.premier,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // First description
                        if (_advice.description.isNotEmpty)
                          Text(
                            _advice.description.first,
                            style: AppTextStyles.inter12Med.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        const SizedBox(height: 10),

                        // Additional images (all share same padding)
                     // Additional images (all share same padding)
if (_advice.imageUrl.length > 1)
  ..._advice.imageUrl.sublist(1).map(
    (img) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  )
else
  Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16), // match style
    ),
    alignment: Alignment.center,
    child: const Text(
      ' ',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  ),

                        const SizedBox(height: 10),

                        // Second description
                        if (_advice.description.length > 1)
                          Text(
                            _advice.description[1],
                            style: AppTextStyles.inter12Med.copyWith(
                              color: AppColors.black,
                            ),
                          ),

                        const SizedBox(height: 10),

                        // Like/Dislike row
                        if (currentUserId != null)
                          AppRowLikeDislike(
                            titletext: 'Cet conseil est-il utile ?',
                            isLiked: _advice.isLikedBy(currentUserId),
                            isDisliked: _advice.isDislikedBy(currentUserId),
                            onLike: () => _vote('like', currentUserId),
                            onDislike: () => _vote('dislike', currentUserId),
                          )
                        else
                          const Text(
                            'Connectez-vous pour voter',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),

                      ],
                      
                    ),
                    
                  ),
                  
                        const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
