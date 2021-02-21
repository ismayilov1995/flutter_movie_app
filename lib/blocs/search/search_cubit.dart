import 'package:bloc/bloc.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/repositories.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(SearchState());

  Repository _repository;

  void searchMovie(String query) async {
    if (query == null || query.isEmpty || query.length < 4) {
      emit(SearchState(movieResponse: null));
    } else {
      final res = await _repository.searchMovies(query);
      if (res.totalResults == 0)
        emit(SearchState(movieResponse: null, notFound: true));
      else
        emit(SearchState(movieResponse: res));
    }
  }

  void clearResults() {
    emit(SearchState(movieResponse: null));
  }
}
