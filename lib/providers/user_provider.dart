import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Load user from local storage or API
  Future<void> loadUser() async {
    try {
      _user = await AuthService().loadUser();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading user: $e');
      _user = null;
      notifyListeners();
    }
  }

  /// Set user manually
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Update user profile
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  /// Add a baby ID to user
  void addBabyToUser(String babyId) {
    if (_user != null && babyId.isNotEmpty && !_user!.babies.contains(babyId)) {
      _user!.babies.add(babyId);
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    _user = null;
    await AuthService().logout();
    notifyListeners();
  }
}
