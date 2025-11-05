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

  /// Add a baby ID to user and persist the updated user locally
  Future<void> addBabyToUser(String babyId) async {
    if (_user != null && babyId.isNotEmpty && !_user!.babies.contains(babyId)) {
      _user!.babies.add(babyId);
      notifyListeners();

      try {
        // Persist updated user so splash/loadUser sees the new baby without re-login
        await AuthService().saveUser(_user!);
        debugPrint('💾 Persisted user with new baby id: $babyId');
      } catch (e) {
        debugPrint('❌ Failed to persist user after adding baby: $e');
      }
    }
  }

  /// Remove a baby ID from the user and persist changes
  Future<void> removeBabyFromUser(String babyId) async {
    if (_user != null && babyId.isNotEmpty && _user!.babies.contains(babyId)) {
      _user!.babies.remove(babyId);
      notifyListeners();

      try {
        await AuthService().saveUser(_user!);
        debugPrint('💾 Persisted user after removing baby id: $babyId');
      } catch (e) {
        debugPrint('❌ Failed to persist user after removing baby: $e');
      }
    }
  }

  /// Logout user
  Future<void> logout() async {
    _user = null;
    await AuthService().logout();
    notifyListeners();
  }
}
