import 'dart:async';

import 'package:movie_app/models/models.dart';
import 'package:movie_app/resources/database_repository.dart';
import 'package:movie_app/resources/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();
  final movieDB = DatabaseRepository();

  Future<MovieResponse> fetchAllMovies({bool isPopular, int page}) async {
    try {
      MovieResponse res;
      res = await movieApiProvider.fetchMovieList(
          isPopular: isPopular, page: page);
      if (isPopular) await movieDB.addMoviesList(res);
      return res;
    } catch (e) {
      print(e);
      return null;
    }
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
    try {
      return await movieApiProvider.fetchMovieTrailers(id);
    } catch (e) {
      return null;
    }
  }

  Future<MovieResponse> searchMovies(String query) {
    return movieApiProvider.searchMovie(query);
  }
}
