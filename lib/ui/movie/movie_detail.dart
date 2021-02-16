import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/genre/genre_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/genre_model.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/widgets/colors.dart';

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
      backgroundColor: kBgColor,
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
      child: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    image: NetworkImage(
                        movie.posterPath.replaceAll('w185', 'w400')))),
          ),
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                    0.1,
                    0.7,
                    1
                  ],
                      colors: [
                    kBgColor.withOpacity(0.0),
                    kBgColor.withOpacity(0.94),
                    kBgColor,
                  ])),
            ),
          ),
          Positioned(
              top: 200,
              left: 20,
              child: Container(
                width: size.width - 40,
                child: Text(
                  movie.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              )),
          Center(child: Text(movie.genres.map((e) => e.name).toString()))
        ],
      ),
    );
  }
}
