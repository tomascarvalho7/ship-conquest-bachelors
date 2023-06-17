import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Programming interface to manage local phone notifications.
class NotificationService {
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Handles notification initialization in Android and iOS by changing the
  /// settings.
  static void initialize() async {
    tz.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('mipmap/ic_launcher');
    const iOsInit = DarwinInitializationSettings(
      requestAlertPermission: true
    );
    const initializationSettings = InitializationSettings(
      android: androidInit,
      iOS: iOsInit
    );
    await notificationsPlugin.initialize(
        initializationSettings
    );
  }

  /// Schedules a notification with the given [id], [title], [body], and [instant].
  static scheduleNotification(int id, String title, String body, DateTime instant) async {
    notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(instant, tz.local),
        _notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Removes a scheduled notification by [id].
  static removeNotification(int id) async {
    notificationsPlugin.cancel(id);
  }

  /// Returns the notification details for Android and iOS platforms.
  static NotificationDetails _notificationDetails()  =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'channel id',
            'channel name',
        ),
        iOS: DarwinNotificationDetails()
      );
}

