import 'package:flutter/material.dart';
import '../models/advice_model.dart';
import '../../theme/dimensions.dart';

class AdviceDetailPage extends StatelessWidget {
  final Advice advice;

  const AdviceDetailPage({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Top image, full width, height 290
            SizedBox(
              height: 290,
              width: double.infinity,
              child: Image.network(
                advice.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // ✅ Content with padding
            Padding(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // ✅ Title 16 semi-bold
                  Text(
                    advice.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ✅ Category left, AFPA right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        advice.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        'AFPA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ✅ Paragraph 12 medium
                  Text(
                    advice.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Full width bottom box 214 height (can be for button or extra content)
                  Container(
                    height: 214,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Text(
                      'Bouton / contenu ici',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
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
}
