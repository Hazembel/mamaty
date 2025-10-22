// lib/widgets/app_avatar_selector.dart
import 'package:flutter/material.dart';
import 'app_avatar.dart';

typedef AvatarSelectedCallback = void Function(int selectedIndex);

class AvatarSelector extends StatefulWidget {
  final List<String> avatars;
  final double size;
  final AvatarSelectedCallback? onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.avatars,
    this.size = 120,
    this.onAvatarSelected,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late final PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = 1;
    _pageController = PageController(
      viewportFraction: 0.38,
      initialPage: selectedIndex,
    );

      // Immediately notify parent after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.onAvatarSelected != null) {
      widget.onAvatarSelected!(selectedIndex);
    }
  });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (widget.onAvatarSelected != null) {
      widget.onAvatarSelected!(index);
    }
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
          final double scale = isSelected ? 1.0 : 0.9;

          return Center(
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Transform.scale(
                scale: scale,
                child: AvatarTile(imagePath: widget.avatars[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
