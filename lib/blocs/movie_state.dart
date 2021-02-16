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
  SuccessFetchMovie(this.movie);

  final Movie movie;
}

class FailFetchMovie extends MovieState {}
