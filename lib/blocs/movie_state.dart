part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class SuccessFetchMovies extends MovieState {
  final ItemModel itemModel;

  SuccessFetchMovies(this.itemModel);
}

class FailFetchMovies extends MovieState {}
