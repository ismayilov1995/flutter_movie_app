import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Map<int, Movie> cachedMovie = Map();
  Map<int, TrailersModel> cachedTrailer = Map();

  Future<ItemModel> fetchAllMovies({bool isPopular}) =>
      movieApiProvider.fetchMovieList(isPopular: isPopular);

  Future<GenresModel> fetchGenreList() => movieApiProvider.fetchGenreList();

  Future<Movie> fetchMovie(int id) async {
    Movie m;
    if (cachedMovie.containsKey(id)) {
      m = cachedMovie[id];
    } else {
      final mov = await movieApiProvider.fetchMovie(id);
      cachedMovie[id] = mov;
      m = mov;
    }
    return m;
  }

  Future<TrailersModel> fetchMovieTrailers(int id) async {
    if (!cachedTrailer.containsKey(id)) {
      cachedTrailer[id] = await movieApiProvider.fetchMovieTrailers(id);
    }
    return cachedTrailer[id];
  }
}
