import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => movieApiProvider.fetchMovieList();

}
