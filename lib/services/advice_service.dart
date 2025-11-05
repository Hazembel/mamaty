import 'dart:convert';
import '../api/api_helper.dart';
import '../models/advice.dart';
import 'package:flutter/foundation.dart';

class AdviceService {
  /// ✅ Get advices for a baby based on age in days
  static Future<List<Advice>> getAdvicesForBaby({
    required String babyId,
    required int ageInDays,
  }) async {
    try {
      final query = '?babyId=$babyId&ageInDays=$ageInDays';
      final response = await ApiHelper.get('/advices/baby$query');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final advices = data.map((json) => Advice.fromJson(json)).toList();

        debugPrint('✅ Fetched ${advices.length} advices for baby $babyId');
        return advices;
      } else {
        throw Exception('Failed to load advices: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error loading advices: $e');
      throw Exception('Failed to load advices: $e');
    }
  }

  /// ✅ Create new advice (admin/protected)
  static Future<Advice> createAdvice(Advice advice) async {
    final response = await ApiHelper.post('/advices', advice.toJson());
    if (response.statusCode == 201) {
      final createdAdvice = Advice.fromJson(jsonDecode(response.body));
      debugPrint('✅ Created advice: ${createdAdvice.id}');
      return createdAdvice;
    } else {
      throw Exception('Failed to create advice: ${response.statusCode}');
    }
  }

  /// ✅ Update advice by ID (admin/protected)
  static Future<Advice> updateAdvice(
    String adviceId,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiHelper.put('/advices/$adviceId', updates);
    if (response.statusCode == 200) {
      final updatedAdvice = Advice.fromJson(jsonDecode(response.body));
      debugPrint('✅ Updated advices: ${updatedAdvice.id}');
      return updatedAdvice;
    } else {
      throw Exception('Failed to update advice: ${response.statusCode}');
    }
  }

  /// ✅ Delete advice by ID (admin/protected)
  static Future<void> deleteAdvice(String adviceId) async {
    final response = await ApiHelper.delete('/advices/$adviceId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete advice: ${response.statusCode}');
    }
    debugPrint('🗑️ Deleted advice $adviceId');
  }

  /// ✅ Vote (like/dislike) an advice
  static Future<Advice> voteAdvice({
    required String adviceId,
    required String userId,
    required String type, // 'like' or 'dislike'
  }) async {
    final response = await ApiHelper.post('/advices/$adviceId/vote', {
      'userId': userId,
      'type': type,
    });

    if (response.statusCode == 200) {
      return Advice.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to vote advice: ${response.statusCode}');
    }
  }
}
