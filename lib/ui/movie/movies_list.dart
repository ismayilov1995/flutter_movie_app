import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/movie_response_model.dart';
import 'package:movie_app/resources/repositories.dart';

class MoviesList extends StatelessWidget {
  static route(BuildContext context, {bool popular = false}) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => MovieBloc(context.read<Repository>()),
                child: MoviesList(popular))));
  }

  MoviesList(this.popular);

  final bool popular;

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovies(popular));
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVIES'),
        centerTitle: true,
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is FailLoadMovies)
            return Center(child: Text('Error while loading'));
          else if (state is SuccessLoadMovies)
            return _successLoadMovies(context, state.movieResponse);
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _successLoadMovies(BuildContext context, MovieResponse movieResponse) {
    final movies = movieResponse.results;
    return GridView.builder(
        itemCount: movies.length,
        gridDelegate:
            SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
        itemBuilder: (context, i) => Card(
              child: Text(movies[i].title),
            ));
  }
}
