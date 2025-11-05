import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/advice.dart';
import '../providers/user_provider.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_row_likedislike.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/dimensions.dart';
import '../services/advice_service.dart'; // your voteAdvice function

class AdviceDetailPage extends StatefulWidget {
  final Advice advice;

  const AdviceDetailPage({super.key, required this.advice});

  @override
  State<AdviceDetailPage> createState() => _AdviceDetailPageState();
}

class _AdviceDetailPageState extends State<AdviceDetailPage> {
  late Advice _advice;

  @override
  void initState() {
    super.initState();
    _advice = widget.advice;
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
  } catch (e) {
    debugPrint('❌ Failed to vote: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impossible de voter pour le moment')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = userProvider.user?.id;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top image + AppTopBar
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
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.pagePadding.horizontal),
                  child: AppTopBar(
                    topMargin: 30,
                    showBack: true,
                    showLogout: false,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _advice.title,
                    style: AppTextStyles.inter16SemiBold.copyWith(color: AppColors.premier),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _advice.category,
                        style: AppTextStyles.inter12Reg.copyWith(color: AppColors.premier),
                      ),
                      Text(
                        _advice.sources != null && _advice.sources!.isNotEmpty
                            ? _advice.sources!.join(' • ')
                            : '',
                        style: AppTextStyles.inter12Reg.copyWith(color: AppColors.premier),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (_advice.description.isNotEmpty)
                    Text(
                      _advice.description.first,
                      style: AppTextStyles.inter12Med.copyWith(color: AppColors.black),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Additional images
            if (_advice.imageUrl.length > 1)
              ..._advice.imageUrl.sublist(1).map(
                (img) => SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(img, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Text(' ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),

            const SizedBox(height: 10),

            // Description 2
            if (_advice.description.length > 1)
              Padding(
                padding: AppDimensions.pagePadding,
                child: Text(
                  _advice.description[1],
                  style: AppTextStyles.inter12Med.copyWith(color: AppColors.black),
                ),
              ),
            const SizedBox(height: 10),

            // Like / Dislike row
            if (currentUserId != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.pagePadding.horizontal),
                child: AppRowLikeDislike(
                  isLiked: _advice.isLikedBy(currentUserId),
                  isDisliked: _advice.isDislikedBy(currentUserId),
                  onLike: () => _vote('like', currentUserId),
                  onDislike: () => _vote('dislike', currentUserId),
                ),
              )
            else
              Padding(
                padding: AppDimensions.pagePadding,
                child: const Text(
                  'Connectez-vous pour voter',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
