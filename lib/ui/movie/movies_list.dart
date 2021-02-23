import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/blocs.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/services/services.dart';
import 'package:movie_app/ui/movie/movie.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class MoviesList extends StatefulWidget {
  static route(BuildContext context, {bool popular = false}) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => MovieBloc(context.read<MovieRepository>()),
                child: MoviesList(popular))));
  }

  MoviesList(this.popular);

  final bool popular;

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovies(widget.popular));
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(widget.popular ? 'POPULAR' : 'NOW PLAYING'),
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
    if (movieResponse == null)
      return Center(child: Text('There is noting to show'));
    final movies = movieResponse.results;
    return GridView.builder(
        controller: _scrollCtrl,
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
                        child: Text('Load more'), onPressed: () => _loadMore()),
                  );
          }
          return _SingleMovieCard(movies[i]);
        });
  }

  void _loadMore() {
    context.read<MovieBloc>().add(LoadMoreMovies(widget.popular));
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
