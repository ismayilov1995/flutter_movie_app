import 'package:movie_app/models/models.dart';

class ItemModel {
  int page, totalPages, totalResults;
  List<Movie> results = [];

  ItemModel.fromJson(Map<String, dynamic> json, bool isRecent) {
    page = json["page"];
    results =
        List<Movie>.from(json["results"].map((x) => Movie.fromMapForHome(x)));
    totalPages = json["total_pages"];
    totalResults = json["total_results"];

    if (isRecent) {
      results.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    } else {
      results.sort((a, b) => b.popularity.compareTo(a.popularity));
    }
  }
}
