import 'package:flutter/src/widgets/framework.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MovieNotificationService {
  factory MovieNotificationService() => _singleton;
  static final MovieNotificationService _singleton =
      MovieNotificationService._internal();

  MovieNotificationService._internal();

  initNotificationService(BuildContext context) {
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  static final _android = AndroidNotificationDetails(
      'movie', 'favorites', 'About favorites movies');
  static final _ios = IOSNotificationDetails();
  final _platform = NotificationDetails(android: _android, iOS: _ios);

  void showNotification(Map<String, dynamic> data) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      data['title'] ?? 'Hey you',
      data['body'] ?? 'We are waiting for u',
      _platform,
      payload: data['payload'],
    );
  }

  setScheduleNotification(Map<String, dynamic> data, DateTime date) async {
    final schedule = ((date.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch) ~/
            1000)
        .abs();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        data['title'] ?? 'Hey you',
        data['body'] ?? 'We are waiting for u',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: schedule)),
        _platform,
        payload: data['payload'],
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      print('Payload is: ' + payload);
    }
    return null;
  }
}
