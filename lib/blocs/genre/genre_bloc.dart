import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/services/services.dart';

part 'genre_event.dart';

part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc(this._repository) : super(GenreInitial());
  final MovieRepository _repository;

  @override
  Stream<GenreState> mapEventToState(
    GenreEvent event,
  ) async* {
    if (event is FetchAllGenres) {
      try {
        final genresModel = await _repository.fetchGenreList();
        yield SuccessFetchGenres(genresModel);
      } catch (e) {
        yield FailFetchGenres();
      }
    }
  }
}
