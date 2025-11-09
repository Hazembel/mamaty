import 'package:flutter/material.dart';
import '../../models/signup_data.dart';
import 'edit_profile_page_1.dart';
import 'edit_profile_page_2.dart';
import 'edit_profile_page_3.dart';
import 'edit_profile_page_4.dart'; 
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_snak_bar.dart';
class EditprofileFlowPage extends StatefulWidget {
  final SignupData userData; // Pass existing user info here

  const EditprofileFlowPage({super.key, required this.userData});

  static void start(BuildContext context, SignupData user) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditprofileFlowPage(userData: user)),
    );
  }

  @override
  State<EditprofileFlowPage> createState() => _EditprofileFlowPageState();
}

class _EditprofileFlowPageState extends State<EditprofileFlowPage> {
  final PageController _pageController = PageController();
  late SignupData editProfileData;

  @override
  void initState() {
    super.initState();
    // Copy the current user data
    editProfileData = SignupData.fromUser(widget.userData);
  }

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> finishEditProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // Call backend update function instead of signup
     final authService = AuthService();
final updatedUser = await authService.updateProfile(
        avatar: editProfileData.avatar,
        gender: editProfileData.gender,
        birthday: editProfileData.birthday,
        name: editProfileData.name ?? '',
        lastname: editProfileData.lastname ?? '',
        email: editProfileData.email ?? '',
        phone: editProfileData.phone ?? '',
      );

      if (updatedUser != null) {
        userProvider.setUser(updatedUser);
       

        if (!mounted) return;

 // ✅ Show success SnackBar in French
      AppSnackBar.show(
        context,
        message: 'Profil mis à jour avec succès 🎉',
      );

        Navigator.of(context).pop(updatedUser); // return updated user
      } else {
        debugPrint('❌ Failed to update profile');
      }
    } catch (e) {
      debugPrint('❌ Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Editprofile1(editProfileData: editProfileData, onNext: nextPage),
          Editprofile2(editProfileData: editProfileData, onNext: finishEditProfile, onBack: prevPage),
          Editprofile3(editProfileData: editProfileData, onNext: nextPage, onBack: prevPage),
          Editprofile4(editProfileData: editProfileData, onFinish: finishEditProfile, onBack: prevPage),
        ],
      ),
    );
  }
}

