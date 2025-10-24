// lib/widgets/app_avatar_selector.dart
import 'package:flutter/material.dart';
import 'app_avatar.dart';

typedef AvatarSelectedCallback = void Function(int selectedIndex);

class AvatarSelector extends StatefulWidget {
  final List<String> avatars;
  final double size;
  final AvatarSelectedCallback? onAvatarSelected;
  final int initialSelectedIndex; // ✅ new

  const AvatarSelector({
    super.key,
    required this.avatars,
    this.size = 120,
    this.onAvatarSelected,
    this.initialSelectedIndex = 1, // ✅ default same as before
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late PageController _pageController;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
    _pageController = PageController(
      viewportFraction: 0.30,
      initialPage: selectedIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onAvatarSelected?.call(selectedIndex);
      }
    });
  }

  // ✅ If parent rebuilds with new avatars or index, update controller
  @override
  void didUpdateWidget(covariant AvatarSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.avatars != widget.avatars ||
        oldWidget.initialSelectedIndex != widget.initialSelectedIndex) {
      setState(() {
        selectedIndex = widget.initialSelectedIndex;
      });
      _pageController.jumpToPage(selectedIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    selectedIndex = index;

    // Call parent callback after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onAvatarSelected?.call(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.avatars.length,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;
          final double scale = isSelected ? 1.0 : 0.8;
          final double opacity = isSelected ? 1.0 : 0.4; // ✅ add opacity
          return Center(
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity, // ✅ apply opacity
                  child: AvatarTile(imagePath: widget.avatars[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
