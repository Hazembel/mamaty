import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Keep this if you have AppColors.defaultShadow

class AppParentRow extends StatefulWidget {
  final List<String> items; // image paths
  final double size; // square size for avatars
  final double spacing; // optional padding between items

  const AppParentRow({
    super.key,
    required this.items,
    this.size = 100,
    this.spacing = 0,
  });

  @override
  State<AppParentRow> createState() => _AppParentRowState();
}

class _AppParentRowState extends State<AppParentRow> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.6, // This creates the overlapping effect
      initialPage: (widget.items.length / 2).floor(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double value = 0;
              if (_controller.position.haveDimensions) {
                value = _controller.page! - index;
              } else {
                value = (_controller.initialPage - index).toDouble();
              }
              value = value.abs();

              // 🎯 Scale side items down more noticeably
              final double scale = (1 - (value * 0.25)).clamp(0.85, 1.0);
              final double opacity = (1 - (value * 0.3)).clamp(0.8, 1.0);

              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [AppColors.defaultShadow],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          widget.items[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
