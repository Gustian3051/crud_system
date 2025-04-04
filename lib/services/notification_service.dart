import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(settings);

    // Request notification permissions for Android
    final androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'praktikum_6_channel_notification',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(0, title, body, details);
  }

  // Notifikasi Khusus

  Future<void> showUpdateNotification(String title) async {
    await showNotification(
      title: 'Task Updated',
      body: 'Task "$title" has been updated.',
    );
  }

  Future<void> showDeleteNotification(String title) async {
    await showNotification(
      title: 'Task Delete',
      body: 'Task "$title" has been deleted.',
    );
  }

  Future<void> showMissedDeadlineNotification(String title) async {
    await showNotification(
      title: 'Missed Deadline',
      body: 'the deadline for "$title" has passed!',
    );
  }
}
