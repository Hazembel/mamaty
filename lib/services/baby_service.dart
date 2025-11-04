import 'dart:convert';
import '../api/api_helper.dart';
import '../models/baby.dart';
import 'package:flutter/foundation.dart';

class BabyService {
  // ✅ Get all babies for a specific user
  static Future<List<Baby>> getBabies() async {
    try {
      final response = await ApiHelper.get('/babies');
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final babies = data.map((json) => Baby.fromJson(json)).toList();

        // Remove duplicates based on ID
        final uniqueBabies = babies
            .fold<Map<String, Baby>>({}, (map, baby) {
              if (baby.id != null && !map.containsKey(baby.id)) {
                map[baby.id!] = baby;
              }
              return map;
            })
            .values
            .toList();

        debugPrint('✅ Fetched ${uniqueBabies.length} unique babies');
        return uniqueBabies;
      } else {
        throw Exception('Failed to load babies: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error loading babies: $e');
      throw Exception('Failed to load babies: $e');
    }
  }

  static Future<Baby> getBaby(String babyId) async {
    final response = await ApiHelper.get('/babies/$babyId');

    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final baby = Baby.fromJson(jsonDecode(response.body));
      debugPrint('✅ Baby fetched: ${baby.id} | ${baby.name}');
      return baby;
    } else {
      throw Exception('Failed to fetch baby: ${response.statusCode}');
    }
  }

  // ✅ Add a new baby
  static Future<Baby> addBaby(Baby baby) async {
    // Make sure baby.toJson() contains 'userId'
    final response = await ApiHelper.post('/babies', baby.toJson());
    if (response.statusCode == 201) {
      return Baby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add baby');
    }
  }

  // ✅ Update baby
  static Future<Baby> updateBaby(
    String babyId,
    Map<String, dynamic> updates,
  ) async {
    final response = await ApiHelper.put('/babies/$babyId', updates);
    if (response.statusCode == 200) {
      return Baby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update baby');
    }
  }

  // ✅ Delete baby
  static Future<void> deleteBaby(String babyId) async {
    final response = await ApiHelper.delete('/babies/$babyId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete baby');
    }
  }

  // ✅ Example: update autorisation only
  static Future<Baby> updateAutorisation(
    String babyId,
    bool autorisation,
  ) async {
    final response = await ApiHelper.put('/babies/$babyId', {
      'autorisation': autorisation,
    });
    if (response.statusCode == 200) {
      return Baby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update autorisation');
    }
  }
}
