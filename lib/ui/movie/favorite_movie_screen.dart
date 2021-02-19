import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/movie_bloc.dart';
import 'package:movie_app/resources/repository.dart';
import 'package:movie_app/ui/movie/movie_detail.dart';
import 'package:movie_app/ui/widgets/widgets.dart';

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
    context.read<MovieBloc>().add(FetchFavorites());
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          title: Text('Your favorite movies'),
          centerTitle: true,
          backgroundColor: kBgColor,
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => removeAllFavorites(context)),
          ],
        ),
        body: _successLoadedFavorites(context, state),
      );
    });
  }

  Widget _successLoadedFavorites(BuildContext context, MovieState state) {
    if (state is SuccessFetchFavoriteMovies) {
      return state.movies != null && state.movies.length > 0
          ? ListView.separated(
              itemCount: state.movies.length,
              padding: EdgeInsets.only(top: 20.0),
              separatorBuilder: (c, _) => Divider(),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                final m = state.movies[i];
                return Dismissible(
                  key: Key(m.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (d) =>
                      context.read<MovieBloc>().add(RemoveFavorites(m.id)),
                  background: Container(
                    alignment: Alignment(0.7, 0),
                    color: Colors.pink,
                    child: Icon(Icons.delete, size: 26),
                  ),
                  child: MovieHorizontalCard(
                    m: m,
                    favBtn: true,
                    onPress: () => MovieDetail.route(context, m.id),
                    onRemove: () =>
                        context.read<MovieBloc>().add(RemoveFavorites(m.id)),
                  ),
                );
              })
          : Center(child: Text('Nothing to show'));
    }
    return Center(child: CircularProgressIndicator());
  }

  void removeAllFavorites(BuildContext context) {
    context.read<MovieBloc>().add(ClearFavorites());
  }
}
