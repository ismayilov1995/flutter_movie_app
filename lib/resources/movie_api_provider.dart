import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movie_app/models/models.dart';

class MovieApiProvider {
  Client client = Client();
  final apiKey = "?api_key=a354cef773ecdfdee470ac417999abd6";
  final baseUrl = "https://api.themoviedb.org/3/";

  Future<ItemModel> fetchMovieList({bool isPopular = false}) async {
    final type = isPopular ? 'movie/popular' : 'movie/now_playing';
    final response = await client.get(baseUrl + type + apiKey);
    if (response.statusCode == 200) {
      return ItemModel.fromJson(jsonDecode(response.body), !isPopular);
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
}
