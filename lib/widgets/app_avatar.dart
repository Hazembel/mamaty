import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../icons/app_icons.dart';

/// Modern AvatarTile with stylish floating edit/delete buttons
class AvatarTile extends StatelessWidget {
  final String imagePath;
  final double size;
  final bool showEditButtons;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AvatarTile({
    super.key,
    required this.imagePath,
    this.size = 120,
    this.showEditButtons = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Avatar
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [AppColors.defaultShadow],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(),
            ),
          ),
        ),

        // Floating Edit/Delete Buttons
        if (showEditButtons)
          Positioned(
            top: -6, // slightly outside the avatar
            right: -6, // slightly outside
            child: Column(
              children: [
                // Edit Button
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: AppIcons.svg(
                        AppIcons.edit,
                        size: 18,
                        color: AppColors.premier, // modern accent color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Delete Button
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: AppIcons.svg(
                        AppIcons.delete,
                        size: 18,
                        color: Colors.redAccent, // modern red
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) return _placeholder();
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.child_care,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
