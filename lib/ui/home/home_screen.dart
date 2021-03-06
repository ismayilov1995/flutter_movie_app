import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/blocs.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/services/services.dart';
import 'package:movie_app/ui/movie/movie.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static route(BuildContext context) {
    final repo = context.read<MovieRepository>();
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<MovieBloc>(create: (context) => MovieBloc(repo)),
                  BlocProvider<GenreBloc>(create: (context) => GenreBloc(repo)),
                  BlocProvider<SearchCubit>(
                      create: (context) => SearchCubit(repo)),
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
                  SearchRow(
                      child: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 0,
                                    child: FlatButton.icon(
                                        icon: Icon(Icons.favorite),
                                        label: Text('Favorites'),
                                        onPressed: () =>
                                            FavoriteMovieScreen.route(
                                                context))),
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
                              ])),
                  _RecentMoviesRow(),
                  _PopularMoviesRow(state.genresModel),
                  Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: AppText(
                        'Powered by: www.themoviedb.org',
                        color: kTextColor,
                      ))
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class _RecentMoviesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCardW(
      title: 'Now playing',
      onPress: () => MoviesList.route(context, popular: false),
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
        HomeCardTitle(
          title: 'Popular',
          onPress: () => MoviesList.route(context, popular: true),
        ),
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
