import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/ui/home/home.dart';
import 'package:movie_app/ui/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static route(BuildContext context) {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
    _setIntroFalse();
  }

  startTime() async {
    var _d = Duration(seconds: 1);
    return Timer(_d, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 120),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ));
  }

  void navigationPage() => HomeScreen.route(context);

  _setIntroFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstRun', false);
  }
}

class MoviePageRouter extends MaterialPageRoute {
  MoviePageRouter({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
