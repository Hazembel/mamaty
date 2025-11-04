import '../models/advice_model.dart';
import '../data/advice_data.dart';

class AdviceService {
  // Simulate getting all advices from backend
  Future<List<Advice>> fetchAllAdvices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return adviceData;
  }

  // Simulate fetching day-specific advice (0–6 months)
  Future<Advice?> fetchAdviceByDay(int day) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return adviceData.firstWhere(
          (advice) => advice.day != null && advice.day == day);
    } catch (_) {
      return null;
    }
  }

  // Simulate fetching advices by age (ranges)
  Future<List<Advice>> fetchAdvicesByAge(int babyAgeInDays) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return adviceData
        .where((advice) =>
            (advice.day != null && advice.day == babyAgeInDays) ||
            (advice.minDay != null &&
                advice.maxDay != null &&
                babyAgeInDays >= advice.minDay! &&
                babyAgeInDays <= advice.maxDay!))
        .toList();
  }
}
