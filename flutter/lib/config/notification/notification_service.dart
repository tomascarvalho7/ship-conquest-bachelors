
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

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

  static removeNotification(int id) async {
    notificationsPlugin.cancel(id);
  }

  static NotificationDetails _notificationDetails()  =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'channel id',
            'channel name',
        ),
        iOS: DarwinNotificationDetails()
      );
}

