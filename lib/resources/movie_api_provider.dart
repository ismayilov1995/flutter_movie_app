import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movie_app/models/models.dart';

class MovieApiProvider {
  Client client = Client();
  final apiKey = "?api_key=a354cef773ecdfdee470ac417999abd6";
  final baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<ItemModel> fetchMovieList() async {
    final response = await client.get(baseUrl + 'now_playing' + apiKey);
    if (response.statusCode == 200) {
      return ItemModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Filed to load posts');
    }
  }
}
