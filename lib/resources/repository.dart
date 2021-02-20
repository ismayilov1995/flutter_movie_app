import 'dart:async';

import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/database_repository.dart';
import 'package:movie_app/resources/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();
  final movieDB = DatabaseRepository();
  Map<int, TrailersModel> cachedTrailer = Map();

  Future<MovieResponse> fetchAllMovies({bool isPopular}) async {
    MovieResponse res;
    res = await movieApiProvider.fetchMovieList(isPopular: isPopular);
    if (isPopular) await movieDB.addMoviesList(res);
    return res;
  }

  Future<GenresModel> fetchGenreList() async {
    GenresModel genresModel;
    if (await movieDB.hasStoredGenres()) {
      genresModel = await movieDB.getGenres();
    } else {
      genresModel = await movieApiProvider.fetchGenreList();
      await movieDB.addGenres(genresModel);
    }
    return genresModel;
  }

  Future<Movie> fetchMovie(int id, {bool refresh = false}) async {
    Movie m;
    if (await movieDB.isMovieStored(id) && !refresh) {
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
