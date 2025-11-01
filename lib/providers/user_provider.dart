import 'package:flutter/foundation.dart';
import '../models/user_data.dart';
import '../services/auth_service.dart';
import '../models/baby_profile_data.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user;
  BabyProfileData? _selectedBaby;

  UserData? get user => _user;
  bool get isLoggedIn => _user != null;

  BabyProfileData? get selectedBaby => _selectedBaby;

  Future<void> loadUser() async {
    _user = await AuthService().loadUserData();
    // Optionally auto-select first baby
    if (_user != null && _user!.babies.isNotEmpty) {
      _selectedBaby = _user!.babies.first;
    }
    notifyListeners();
  }

  void setUser(UserData user) {
    _user = user;
    if (_user!.babies.isNotEmpty) _selectedBaby = _user!.babies.first;
    notifyListeners();
  }

  void selectBaby(BabyProfileData baby) {
    _selectedBaby = baby;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _selectedBaby = null;
    await AuthService().logout();
    notifyListeners();
  }
}
