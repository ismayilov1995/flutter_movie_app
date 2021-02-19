part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}

class FetchAllMovies extends MovieEvent {}

class FetchMovie extends MovieEvent {
  FetchMovie(this.id, {this.refresh = false});

  final int id;
  final bool refresh;
}

class PlayTrailer extends MovieEvent {
  PlayTrailer(this.videoKey);

  final String videoKey;
}

class AddToFavorite extends MovieEvent {
  AddToFavorite(this.movieID);

  final int movieID;
}

class FetchFavorites extends MovieEvent {}

class RemoveFavorites extends MovieEvent {
  RemoveFavorites(this.movieID);

  final int movieID;
}

class ClearFavorites extends MovieEvent {}

class ClearMovieCache extends MovieEvent {}
