import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movie_app/resources/notification_service.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/intro_screen.dart';
import 'package:movie_app/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    MovieNotificationService().initNotificationService(context);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => Repository(),
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<bool>(
            future: _checkFirstRun(),
            builder: (context, snap) {
              if (snap.data == null || snap.data) {
                return IntroScreen();
              } else {
                return SplashScreen();
              }
            }),
      ),
    );
  }

  Future<bool> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstRun') ?? true;
  }
}
