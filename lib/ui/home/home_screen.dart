import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/genre/genre_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/models/genre_model.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:movie_app/ui/movie/favorite_movie_screen.dart';
import 'package:movie_app/ui/movie/movie_detail.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static route(BuildContext context) {
    final repo = context.read<Repository>();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<MovieBloc>(create: (context) => MovieBloc(repo)),
                  BlocProvider<GenreBloc>(create: (context) => GenreBloc(repo)),
                ], child: HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchAllMovies());
    context.read<GenreBloc>().add(FetchAllGenres());
    return Scaffold(backgroundColor: kBgColor, body: _HomeScreenBody());
  }
}

class _HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) => state is SuccessFetchGenres
          ? SafeArea(
              child: ListView(
                primary: false,
                children: [
                  _SearchRow(),
                  _RecentMoviesRow(),
                  _PopularMoviesRow(state.genresModel),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class _SearchRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
              PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 0,
                            child: FlatButton.icon(
                                icon: Icon(Icons.favorite),
                                label: Text('Favorites'),
                                onPressed: () =>
                                    FavoriteMovieScreen.route(context))),
                        PopupMenuItem(
                            value: 1,
                            child: FlatButton.icon(
                              icon: Icon(Icons.clear_all),
                              label: Text('Clear cache'),
                              onPressed: () {
                                context
                                    .read<MovieBloc>()
                                    .add(ClearMovieCache());
                                Navigator.pop(context);
                              },
                            )),
                      ])
            ],
          ),
          SizedBox(height: 6),
          TextField(
            style: TextStyle(color: kTextColor, fontSize: 28),
            decoration: InputDecoration.collapsed(
                hintText: 'Movie, Actors, Directors...',
                hintStyle: TextStyle(color: kTextColor, fontSize: 28),
                border: UnderlineInputBorder()),
          ),
        ],
      ),
    );
  }
}

class _RecentMoviesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCardW(
      title: 'Recent',
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovies) {
            return state.recent != null
                ? Container(
                    height: 230,
                    child: ListView.builder(
                        primary: false,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recent.results.length,
                        itemBuilder: (context, i) {
                          final m = state.recent.results[i];
                          return MovieCard(
                            title: m.title,
                            posterPath: m.poster,
                            onPress: () => MovieDetail.route(context, m.id),
                          );
                        }))
                : Center(child: CircularProgressIndicator());
          } else if (state is FailFetchMovies) {
            return Center(child: Text('Failed while loading movies'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PopularMoviesRow extends StatelessWidget {
  _PopularMoviesRow(this.genresModel);

  final GenresModel genresModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeCardTitle(title: 'Popular'),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is SuccessFetchMovies) {
              return state.popular != null
                  ? ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.popular.results.length,
                      separatorBuilder: (context, i) => Divider(),
                      itemBuilder: (context, i) {
                        final m = state.popular.results[i];
                        return MovieHorizontalCard(
                          m: m,
                          genresModel: genresModel,
                          onPress: () => MovieDetail.route(context, m.id),
                        );
                      })
                  : Center(child: CircularProgressIndicator());
            } else if (state is FailFetchMovies) {
              return Center(child: Text('Failed while loading movies'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
