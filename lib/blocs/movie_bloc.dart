import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/item_model.dart';
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
      try {
        final res = await _repository.fetchAllMovies();
        yield SuccessFetchMovies(res);
      } catch (e) {
        yield FailFetchMovies();
      }
    }
  }
}