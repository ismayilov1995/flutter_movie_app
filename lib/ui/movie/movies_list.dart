import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/models/movie_response_model.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/movie/movie_detail.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

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
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(popular ? 'POPULAR' : 'NOW PLAYING'),
        centerTitle: true,
        backgroundColor: kBgColor,
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
        padding: EdgeInsets.all(5.0),
        itemCount: movies.length + 1,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, childAspectRatio: 0.69),
        itemBuilder: (context, i) {
          if (i == movies.length) {
            return movieResponse.totalPages == movieResponse.page
                ? Center()
                : Center(
                    child: FlatButton(
                        child: Text('Load more'),
                        onPressed: () => context
                            .read<MovieBloc>()
                            .add(LoadMoreMovies(popular))),
                  );
          }
          return _SingleMovieCard(movies[i]);
        });
  }
}

class _SingleMovieCard extends StatelessWidget {
  _SingleMovieCard(this.movie);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () => MovieDetail.route(context, movie.id),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedImage(movie.poster),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                constraints: BoxConstraints(minHeight: 50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black,
                      ],
                      stops: [0, 0.2, 1],
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(movie.title),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
