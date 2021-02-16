import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/item_model.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/repositories.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(this._repository) : super(MovieInitial());
  final Repository _repository;

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
        yield SuccessFetchMovie(response);
      } catch (e) {
        print(e);
        yield FailFetchMovie();
      }
    }
  }
}
