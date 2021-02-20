import 'package:bloc/bloc.dart';
import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/repositories.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(SearchState());

  Repository _repository;

  void searchMovie(String query) async {
    if (query == null || query.length < 4) return;
    final res = await _repository.searchMovies(query);
    emit(SearchState(movieResponse: res));
  }
}
