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
    if (_isLoading) {
      debugPrint('🔄 Already loading babies, skipping...');
      return;
    }

    if (babyIds.isEmpty) {
      debugPrint('ℹ️ No baby IDs to load');
      _babies.clear();
      _selectedBaby = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Get unique IDs only
      final uniqueIds = babyIds.toSet();
      debugPrint('🍼 Loading ${uniqueIds.length} unique babies...');

      // Filter out IDs we already have loaded
      final idsToLoad = uniqueIds
          .where((id) => !_babies.any((b) => b.id == id))
          .toList();

      if (idsToLoad.isEmpty) {
        debugPrint('✅ All babies already loaded');
        return;
      }

      // Load babies one-by-one and tolerate not-found errors so a single missing
      // baby doesn't abort the whole load. This also gives clearer logging.
      int loadedCount = 0;
      for (final id in idsToLoad) {
        try {
          final baby = await BabyService.getBaby(id);
          if (!_babies.any((b) => b.id == baby.id)) {
            _babies.add(baby);
            loadedCount++;
          }
        } catch (e) {
          debugPrint('⚠️ Skipping baby id=$id due to error: $e');
          // continue to next id
        }
      }

      debugPrint('✅ Loaded $loadedCount new babies');

      // Update selected baby if needed
      if (_selectedBaby == null && _babies.isNotEmpty) {
        _selectedBaby = _babies.first;
      }
    } catch (e) {
      debugPrint('❌ Failed to load babies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
