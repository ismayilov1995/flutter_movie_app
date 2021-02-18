import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/resources/repository.dart';

class FavoriteMovieScreen extends StatelessWidget {
  static route(BuildContext context) => Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => MovieBloc(context.read<Repository>()),
            child: FavoriteMovieScreen()),
      ));

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
