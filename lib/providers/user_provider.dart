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

  /// Toggle a doctor as favorite
  Future<void> toggleFavoriteDoctor(String doctorId) async {
    if (_user == null) return;

    final isFavorite = _user!.doctors.contains(doctorId);

    if (isFavorite) {
      _user!.doctors.remove(doctorId);
    } else {
      _user!.doctors.add(doctorId);
    }

    notifyListeners();

    try {
      await AuthService().saveUser(_user!); // persist changes
      debugPrint('💾 Updated favorite doctors: ${_user!.doctors}');
    } catch (e) {
      debugPrint('❌ Failed to save user after toggling favorite: $e');
    }
  }

/// Toggle a recipe as favorite
Future<void> toggleFavoriteRecipe(String recipeId) async {
  if (_user == null || recipeId.isEmpty) return;

  // Ensure the recipes list is initialized
  _user!.recipes = _user!.recipes  ;

  final isFavorite = _user!.recipes.contains(recipeId);

  if (isFavorite) {
    _user!.recipes.remove(recipeId);
  } else {
    _user!.recipes.add(recipeId);
  }

  notifyListeners();

  try {
    await AuthService().saveUser(_user!); // persist changes locally
    debugPrint('💾 Updated favorite recipes: ${_user!.recipes}');
  } catch (e) {
    debugPrint('❌ Failed to save user after toggling favorite recipe: $e');
  }
}



  /// Add a baby ID to user and persist the updated user locally
  Future<void> addBabyToUser(String babyId) async {
    if (_user != null && babyId.isNotEmpty && !_user!.babies.contains(babyId)) {
      _user!.babies.add(babyId);
      notifyListeners();

      try {
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

