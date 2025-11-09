import 'package:flutter/material.dart';
import '../widgets/app_top_bar_text.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../theme/dimensions.dart';
import '../icons/app_icons.dart'; // make sure this is imported
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
Future<void> _makeCall(String phone) async {
  final cleanedPhone = phone.replaceAll(' ', '');
  final Uri phoneUri = Uri.parse('tel:$cleanedPhone');

  try {
    await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('❌ Could not launch phone dialer: $e');
  }
}

Future<void> _sendEmail(String email) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=Contact&body=Bonjour',
  );

  try {
    await launchUrl(emailUri);
  } catch (e) {
    debugPrint('❌ Could not launch email app: $e');
  }
}

Future<void> _openSocial(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('❌ Could not launch URL: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppDimensions.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTopBarText(
                    title: 'Contactez-nous',
                    onBack: () => Navigator.of(context).pop(),
                    topMargin: 30,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'N’hésitez pas à nous contacter si vous avez une suggestion d’amélioration, une réclamation à discuter ou un problème à résoudre',
                    style: AppTextStyles.inter14Med.copyWith(
                      color: AppColors.premier,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons (Call / Email) centered with fixed width
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [AppColors.defaultShadow],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                           _makeCall('+123456789') ;
                            },
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.call,
                                    color: AppColors.premier,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Appeler',
                                    style: AppTextStyles.inter14Med.copyWith(
                                      color: AppColors.premier,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 150,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [AppColors.defaultShadow],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                             _sendEmail('contact@yourmail.com');
                            },
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: AppColors.premier,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Email',
                                    style: AppTextStyles.inter14Med.copyWith(
                                      color: AppColors.premier,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Social media label
                  Center(
                    child: Text(
                      'SOCIAL MEDIA',
                      style: AppTextStyles.inter12Med.copyWith(
                        color: AppColors.lightPremier,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Social grid: white cards with default shadow (centered)
                  Center(
                    child: Wrap(
  alignment: WrapAlignment.center,
  runAlignment: WrapAlignment.center,
  spacing: 12,
  runSpacing: 12,
  children: [
    _socialCard(
      iconName: AppIcons.instagram,
      title: 'Instagram',
      subtitle: '@mamty',
        url: 'https://www.facebook.com/mamaty',
    ),
    _socialCard(
      iconName: AppIcons.facebook,
      title: 'Facebook',
      subtitle: '/mamaty',
        url: 'https://www.instagram.com/mamty',
    ),
    _socialCard(
      iconName: AppIcons.whatsapp,
      title: 'WhatsApp',
      subtitle: '+123456789',
         url: 'https://wa.me/123456789',
    ),
  ],
)

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
Widget _socialCard({
  required String iconName,
  required String title,
  required String subtitle,
  required String url, // Add URL
}) {
  return SizedBox(
    width: 180,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openSocial(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [AppColors.defaultShadow],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcons.svg(iconName, size: 20, color: AppColors.premier),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTextStyles.inter14Med.copyWith(color: AppColors.premier)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.inter12Med.copyWith(color: AppColors.lightPremier)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}





}
