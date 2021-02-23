import 'package:flutter/material.dart';
import 'package:movie_app/ui/movie/movie.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MovieNotificationService {
  BuildContext _context;

  factory MovieNotificationService() => _singleton;
  static final MovieNotificationService _singleton =
      MovieNotificationService._internal();

  MovieNotificationService._internal();

  initNotificationService(BuildContext context) {
    _context = context;
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('app_icon');
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
      data['id'],
      data['title'] ?? 'Hey you',
      data['body'] ?? 'We are waiting for u',
      _platform,
      payload: data['payload'],
    );
  }

  setScheduleNotification(Map<String, dynamic> data, DateTime date) async {
    // Clear notification if set before
    clearNotification(data['id']);
    final schedule = ((date.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch) ~/
            1000)
        .abs();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        data['id'],
        data['title'] ?? 'Hey you',
        data['body'] ?? 'We are waiting for u',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: schedule)),
        _platform,
        payload: data['payload'],
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  clearNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  clearAllNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Payload is: ' + payload);
      // not working, I couldn't figurate the reason
      MovieDetail.route(_context, int.parse(payload));
    }
  }
}
