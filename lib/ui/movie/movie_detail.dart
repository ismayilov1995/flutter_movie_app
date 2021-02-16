import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/resources/repositories.dart';

class MovieDetail extends StatelessWidget {
  static route(BuildContext context, int id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => MovieBloc(context.read<Repository>()),
                child: MovieDetail(id))));
  }

  MovieDetail(this.movieId);

  final int movieId;

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovie(this.movieId));
    return Scaffold(
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovie) {
            return _scaffoldBody(context, state.movie);
          } else if (state is FailFetchMovie) {
            return Center(child: Text('Error while load details'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _scaffoldBody(BuildContext context, Movie movie) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Center(child: Text(movie.title)),
    );
  }
}
