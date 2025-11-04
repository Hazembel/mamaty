import 'package:flutter/material.dart';
import '../models/advice_model.dart';
import '../services/advice_service.dart';

class AdviceProvider extends ChangeNotifier {
  final AdviceService _service = AdviceService();

  List<Advice> _advices = [];
  bool _isLoading = false;

  List<Advice> get advices => _advices;
  bool get isLoading => _isLoading;

  // Load advices for specific baby age
  Future<void> loadAdvicesForAge(int babyAgeInDays) async {
    _isLoading = true;
    notifyListeners();

    _advices = await _service.fetchAdvicesByAge(babyAgeInDays);

    _isLoading = false;
    notifyListeners();
  }

  // Load day-specific advice (0–6 months)
  Future<Advice?> loadAdviceForDay(int day) async {
    _isLoading = true;
    notifyListeners();

    final advice = await _service.fetchAdviceByDay(day);

    _isLoading = false;
    notifyListeners();
    return advice;
  }
}
