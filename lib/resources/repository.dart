import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/database_repository.dart';
import 'package:movie_app/resources/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();
  final movieDB = DatabaseRepository();

  Map<int, Movie> cachedMovie = Map();
  Map<int, TrailersModel> cachedTrailer = Map();

  Future<MovieResponse> fetchAllMovies({bool isPopular}) =>
      movieApiProvider.fetchMovieList(isPopular: isPopular);

  Future<GenresModel> fetchGenreList() => movieApiProvider.fetchGenreList();

  Future<Movie> fetchMovie(int id) async {
    Movie m;
    if (await movieDB.isMovieStored(id)) {
      m = await movieDB.getMovie(id);
    } else {
      final mov = await movieApiProvider.fetchMovie(id);
      await movieDB.addMovie(mov);
      m = mov;
    }
    m.favorite = await movieDB.isFavorite(id);
    return m;
  }

  Future<TrailersModel> fetchMovieTrailers(int id) async {
    if (!cachedTrailer.containsKey(id)) {
      cachedTrailer[id] = await movieApiProvider.fetchMovieTrailers(id);
    }
    return cachedTrailer[id];
  }
}
