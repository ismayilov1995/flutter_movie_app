class ItemModel {
  int page, totalPages, totalResults;
  List<Result> results = [];

  ItemModel.fromJson(Map<String, dynamic> json, bool isRecent) {
    page = json["page"];
    results = List<Result>.from(json["results"].map((x) => Result.fromMap(x)));
    totalPages = json["total_pages"];
    totalResults = json["total_results"];

    if (isRecent) {
      results.sort(
              (a, b) => b.releaseDate.compareTo(a.releaseDate));
    } else {
      results.sort(
              (a, b) => b.popularity.compareTo(a.popularity));
    }
  }
}

class Result {
  Result({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  factory Result.fromMap(Map<String, dynamic> json) =>
      Result(
        adult: json["adult"],
        backdropPath:
        'https://image.tmdb.org/t/p/w185' + json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: 'https://image.tmdb.org/t/p/w185' + json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  DateTime get getReleaseDate => releaseDate;

  String get getOverview => overview;
}
