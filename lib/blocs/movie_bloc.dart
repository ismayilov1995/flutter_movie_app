import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/item_model.dart';
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
      try {
        sqfRepository.favoriteMovie(event.movie);
      } catch (e) {
        print(e);
      }
    } else if (event is FetchFavorites) {
      try {
        final res = await sqfRepository.getFavoritesMovie();
        print(res.length);
      } catch (e) {
        print(e);
      }
    } else if (event is RemoveFavorites) {
      try {
        await sqfRepository.removeFavoritesMovie(event.movieID);
      } catch (e) {
        print(e);
      }
    } else if (event is ClearFavorites) {
      try {
        await sqfRepository.removeAllFavorites();
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
