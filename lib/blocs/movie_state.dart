part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class SuccessFetchMovies extends MovieState {
  SuccessFetchMovies({this.recent, this.popular});

  final ItemModel recent, popular;
}

class FailFetchMovies extends MovieState {}

class SuccessFetchMovie extends MovieState {
  SuccessFetchMovie({this.movie, this.trailersModel});

  final Movie movie;
  final TrailersModel trailersModel;
}

class FailFetchMovie extends MovieState {}

class SuccessFavoriteMovie extends MovieState {
  SuccessFavoriteMovie(this.text);

  final String text;
}
