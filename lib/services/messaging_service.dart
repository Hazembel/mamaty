import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../api/api_helper.dart'; // your backend API helper

class MessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Request permissions (iOS)
    await _messaging.requestPermission();

    // Get FCM token
    String? token = await _messaging.getToken();
    if (token != null) {
      print('✅ FCM Token: $token');
      // Send token to backend
      await _sendTokenToBackend(token);
    }

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground notification: ${message.notification?.title}');
      _showLocalNotification(
        message.notification?.title ?? '',
        message.notification?.body ?? '',
      );
    });

    // Background / terminated notifications are handled by onBackgroundMessage
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification clicked: ${message.data}');
      // Navigate to article / recipe page if needed
    });

    // Initialize local notifications (Android)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(initializationSettings);
  }

  // --- helper to get token at any time ---
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  // --- helper to send token to backend at any time ---
  static Future<void> sendTokenToBackend(String token) async {
    try {
      await ApiHelper.post('/users/fcm-token', {'fcmToken': token});
      print('✅ FCM token sent to backend');
    } catch (e) {
      print('❌ Failed to send FCM token to backend: $e');
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    await sendTokenToBackend(token);
  }

  static Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'mamaty_channel', // channel id
      'Mamaty Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, notificationDetails);
  }
}
