import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/genre/genre_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/home/home.dart';
import 'package:movie_app/ui/widgets/colors.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
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
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _d = Duration(seconds: 2);
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

  void navigationPage() {
    final repo = context.read<Repository>();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<MovieBloc>(create: (context) => MovieBloc(repo)),
                  BlocProvider<GenreBloc>(create: (context) => GenreBloc(repo)),
                ], child: HomeScreen())));
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
