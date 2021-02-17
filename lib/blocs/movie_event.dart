part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}

class FetchAllMovies extends MovieEvent {}

class FetchMovie extends MovieEvent {
  FetchMovie(this.id);

  final int id;
}

class PlayTrailer extends MovieEvent {
  PlayTrailer(this.videoKey);

  final String videoKey;
}
