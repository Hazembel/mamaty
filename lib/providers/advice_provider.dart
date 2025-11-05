import 'package:flutter/foundation.dart';
import '../models/advice.dart';
import '../services/advice_service.dart';

class AdviceProvider extends ChangeNotifier {
  final List<Advice> _advices = [];
  bool _isLoading = false;

  List<Advice> get advices => _advices;
  bool get isLoading => _isLoading;

  /// Load advices for a specific baby and age
  Future<void> loadAdvices({
    required String babyId,
    required int ageInDays,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedAdvices = await AdviceService.getAdvicesForBaby(
        babyId: babyId,
        ageInDays: ageInDays,
      );

      _advices
        ..clear()
        ..addAll(fetchedAdvices);

      debugPrint('✅ Loaded ${_advices.length} advices for baby $babyId');
    } catch (e) {
      debugPrint('❌ Failed to load advices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new advice (admin)
  void addAdvice(Advice advice) {
    if (!_advices.any((a) => a.id == advice.id)) {
      _advices.add(advice);
      notifyListeners();
    }
  }

  /// Update existing advice
  void updateAdvice(Advice updatedAdvice) {
    final index = _advices.indexWhere((a) => a.id == updatedAdvice.id);
    if (index != -1) {
      _advices[index] = updatedAdvice;
      notifyListeners();
    }
  }

  /// Remove advice
  void removeAdvice(String adviceId) {
    _advices.removeWhere((a) => a.id == adviceId);
    notifyListeners();
  }

  /// Vote (like or dislike) an advice for a specific user
  Future<void> voteAdvice(Advice advice, String userId, String type) async {
    try {
      final updatedAdvice = await AdviceService.voteAdvice(
        adviceId: advice.id!,
        userId: userId,
        type: type,
      );

      // Update local advice
      advice.likes = updatedAdvice.likes;
      advice.dislikes = updatedAdvice.dislikes;
      notifyListeners(); // if inside provider
    } catch (e) {
      debugPrint('❌ Failed to vote advice: $e');
    }
  }
}
