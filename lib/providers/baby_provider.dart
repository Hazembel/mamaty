import 'package:flutter/foundation.dart';
import '../models/baby.dart';
import '../services/baby_service.dart';

class BabyProvider extends ChangeNotifier {
  final List<Baby> _babies = [];
  Baby? _selectedBaby;
  bool _isLoading = false;

  List<Baby> get babies => _babies;
  Baby? get selectedBaby => _selectedBaby;
  bool get isLoading => _isLoading;

  /// Load babies by IDs (handles duplicates)
  Future<void> loadBabies(List<String> babyIds) async {
    if (_isLoading) return; // prevent multiple concurrent calls
    _isLoading = true;
    notifyListeners();

    _babies.clear();
    final uniqueIds = babyIds.toSet();

    for (var id in uniqueIds) {
      try {
        final baby = await BabyService.getBaby(id);
        if (!_babies.any((b) => b.id == baby.id)) {
          _babies.add(baby);
        }
      } catch (e) {
        debugPrint('❌ Failed to fetch baby $id: $e');
      }
    }

    if (_babies.isNotEmpty) {
      _selectedBaby = _babies.first;
    } else {
      _selectedBaby = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Select a baby
  void selectBaby(Baby baby) {
    _selectedBaby = baby;
    notifyListeners();
  }

  /// Add a new baby
  void addBaby(Baby baby) {
    if (!_babies.any((b) => b.id == baby.id)) {
      _babies.add(baby);
    }
    _selectedBaby = baby;
    notifyListeners();
  }

  /// Update a baby
  void updateBaby(Baby updatedBaby) {
    final index = _babies.indexWhere((b) => b.id == updatedBaby.id);
    if (index != -1) {
      _babies[index] = updatedBaby;
      if (_selectedBaby != null && _selectedBaby!.id == updatedBaby.id) {
        _selectedBaby = updatedBaby;
      }
      notifyListeners();
    }
  }

  /// Remove a baby
  void removeBaby(String babyId) {
    _babies.removeWhere((b) => b.id == babyId);
    if (_selectedBaby != null && _selectedBaby!.id == babyId) {
      _selectedBaby = _babies.isNotEmpty ? _babies.first : null;
    }
    notifyListeners();
  }
}
