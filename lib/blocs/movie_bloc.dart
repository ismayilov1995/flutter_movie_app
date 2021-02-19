import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/movie_response_model.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/database_repository.dart';
import 'package:movie_app/resources/repositories.dart';
import 'package:url_launcher/url_launcher.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(this._repository) : super(MovieInitial());
  final Repository _repository;
  final sqfRepository = DatabaseRepository();

  @override
  Stream<MovieState> mapEventToState(
    MovieEvent event,
  ) async* {
    if (event is FetchAllMovies) {
      yield SuccessFetchMovies();
      try {
        if (state is SuccessFetchMovies) {
          final recRes = await _repository.fetchAllMovies(isPopular: false);
          yield SuccessFetchMovies(recent: recRes);
          final popRes = await _repository.fetchAllMovies(isPopular: true);
          yield SuccessFetchMovies(recent: recRes, popular: popRes);
        }
      } catch (e) {
        print(e);
        yield FailFetchMovies();
      }
    } else if (event is FetchMovie) {
      try {
        final response = await _repository.fetchMovie(event.id);
        yield SuccessFetchMovie(movie: response);
        final trailerRes = await _repository.fetchMovieTrailers(event.id);
        yield SuccessFetchMovie(movie: response, trailersModel: trailerRes);
      } catch (e) {
        print(e);
        yield FailFetchMovie();
      }
    } else if (event is PlayTrailer) {
      try {
        await _launchURL('https://www.youtube.com/watch?v=' + event.videoKey);
      } catch (e) {
        print(e);
      }
    } else if (event is AddToFavorite) {
      final s = (state as SuccessFetchMovie);
      try {
        s.movie.favorite = await sqfRepository.favoriteMovie(event.movieID);
        yield SuccessFavoriteMovie(s.movie.favorite ? 'Added' : 'Removed');
        yield s;
      } catch (e) {
        yield SuccessFavoriteMovie('Error while added');
        yield s;
      }
    } else if (event is FetchFavorites) {
      try {
        final res = await sqfRepository.getFavoritesMovie();
        yield SuccessFetchFavoriteMovies(res);
      } catch (e) {
        print(e);
      }
    } else if (event is RemoveFavorites) {
      try {
        final s = (state as SuccessFetchFavoriteMovies);
        await sqfRepository.removeFavoritesMovie(event.movieID);
        yield SuccessFetchFavoriteMovies(
            s.movies.where((e) => e.id != event.movieID).toList());
      } catch (e) {
        print(e);
      }
    } else if (event is ClearFavorites) {
      try {
        await sqfRepository.removeAllFavorites();
        yield SuccessFetchFavoriteMovies([]);
      } catch (e) {
        print(e);
      }
    } else if (event is ClearMovieCache) {
      try {
        await sqfRepository.removeMovies();
        print('Cache cleared');
      } catch (e) {
        print(e);
      }
    }
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('can\'t launch');
  }
}
