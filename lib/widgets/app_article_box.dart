import 'package:flutter/material.dart';

class AppArticleBox extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String category;
  final String timeAgo;
  final VoidCallback? onTap;

  const AppArticleBox({
    super.key,
    required this.title,
    required this.imageUrl,
    this.category = '',
    this.timeAgo = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth > 0 ? constraints.maxWidth : 332.0;
        final imageWidth = 139.0;
        final imageHeight = 140.0;
        final spacing = 12.0;
        final borderRadius = 16.0;

        return Container(
          width: width,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image.network(
                  imageUrl,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: imageWidth,
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(width: spacing),

              // 🔹 Text Column
              Expanded(
                child: SizedBox(
                  height: imageHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 0),
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),
                      // Category
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 10),
                      // Time ago
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
