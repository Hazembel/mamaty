import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/border_radius.dart';
import '../icons/app_icons.dart';
 
import '../../theme/text_styles.dart';

class AppRowLikeDislike extends StatefulWidget {
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const AppRowLikeDislike({
    super.key,
    this.isLiked = false,
    this.isDisliked = false,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<AppRowLikeDislike> createState() => _AppRowLikeDislikeState();
}

class _AppRowLikeDislikeState extends State<AppRowLikeDislike>
    with SingleTickerProviderStateMixin {
  double _likeScale = 1.0;
  double _dislikeScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left text
        Expanded(
          child: Text(
            'Cet conseil est-il utile ?',
            style: AppTextStyles.inter16medium.copyWith(color: AppColors.premier),
          ),
        ),

        // Like button
        GestureDetector(
          onTapDown: (_) => setState(() => _likeScale = 0.9),
          onTapUp: (_) => setState(() => _likeScale = 1.0),
          onTapCancel: () => setState(() => _likeScale = 1.0),
          onTap: widget.onLike,
          child: AnimatedScale(
            scale: _likeScale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppBorders.all,
                boxShadow: [AppColors.defaultShadow],
              ),
              alignment: Alignment.center,
              child: AppIcons.svg(
                widget.isLiked ? AppIcons.liked : AppIcons.like,
                size: 22,
                color: widget.isLiked ? AppColors.premier : AppColors.black,
              ),
            ),
          ),
        ),

        // Dislike button
        GestureDetector(
          onTapDown: (_) => setState(() => _dislikeScale = 0.9),
          onTapUp: (_) => setState(() => _dislikeScale = 1.0),
          onTapCancel: () => setState(() => _dislikeScale = 1.0),
          onTap: widget.onDislike,
          child: AnimatedScale(
            scale: _dislikeScale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppBorders.all,
                boxShadow: [AppColors.defaultShadow],
              ),
              alignment: Alignment.center,
              child: AppIcons.svg(
                widget.isDisliked ? AppIcons.disliked : AppIcons.dislike,
                size: 22,
                color: widget.isDisliked ? Colors.red : AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
