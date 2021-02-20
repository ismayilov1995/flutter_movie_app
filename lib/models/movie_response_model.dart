import 'package:movie_app/models/models.dart';

class MovieResponse {
  int page, totalPages, totalResults;
  List<Movie> results = [];

  MovieResponse.fromJson(Map<String, dynamic> json, bool isRecent) {
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

  Map<String, dynamic> toMap() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toMapSqf())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
