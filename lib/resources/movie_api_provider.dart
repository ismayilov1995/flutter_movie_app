import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movie_app/models/models.dart';

class MovieApiProvider {
  Client client = Client();
  final apiKey = "?api_key=a354cef773ecdfdee470ac417999abd6";
  final baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<ItemModel> fetchMovieList({bool isPopular = false}) async {
    final type = isPopular ? 'popular' : 'now_playing';
    final response = await client.get(baseUrl + type + apiKey);
    if (response.statusCode == 200) {
      return ItemModel.fromJson(jsonDecode(response.body), !isPopular);
    } else {
      throw Exception('Filed to load posts');
    }
  }
}
