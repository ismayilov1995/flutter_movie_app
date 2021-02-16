part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}

class FetchAllMovies extends MovieEvent {
  FetchAllMovies({this.isPopular = false});

  final bool isPopular;
}
