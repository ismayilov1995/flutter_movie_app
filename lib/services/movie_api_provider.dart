import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movie_app/models/models.dart';

class MovieApiProvider {
  Client client = Client();
  final apiKey = "?api_key=a354cef773ecdfdee470ac417999abd6";
  final baseUrl = "https://api.themoviedb.org/3/";

  Future<MovieResponse> fetchMovieList(
      {bool isPopular = false, int page = 1}) async {
    final type = isPopular ? 'movie/popular' : 'movie/now_playing';
    final response = await client.get(baseUrl + type + apiKey + '&page=$page');
    if (response.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(response.body), !isPopular);
    } else {
      throw Exception('Filed to load posts');
    }
  }

  Future<Movie> fetchMovie(int id) async {
    final response = await client.get('${baseUrl}movie/$id$apiKey');
    if (response.statusCode == 200) {
      return movieFromMap(response.body);
    } else {
      throw Exception('Filed to load posts');
    }
  }

  Future<GenresModel> fetchGenreList() async {
    final response = await client.get(baseUrl + 'genre/movie/list' + apiKey);
    if (response.statusCode == 200) {
      return GenresModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Filed to load genres');
    }
  }

  Future<TrailersModel> fetchMovieTrailers(int id) async {
    final response = await client.get('${baseUrl}movie/$id/videos$apiKey');
    if (response.statusCode == 200) {
      return trailersModelFromMap(response.body);
    } else {
      throw Exception('Filed to load trailers');
    }
  }

  Future<MovieResponse> searchMovie(String query) async {
    final path =
        '${baseUrl}search/multi$apiKey&query=$query&include_adult=true';
    final res = await client.get(path);
    if (res.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(res.body), false);
    } else {
      throw Exception('Filed to load search');
    }
  }
}
