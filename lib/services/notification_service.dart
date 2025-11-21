// services/notification_service.dart
import 'dart:convert';
import '../api/api_helper.dart';
import '../../models/notification.dart';

class NotificationService {
  /// Get notifications for the current user
  static Future<List<NotificationModel>> getNotifications() async {
    final response = await ApiHelper.get('/notifications');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }
}
