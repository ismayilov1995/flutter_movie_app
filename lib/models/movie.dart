import 'dart:convert';

import 'package:movie_app/models/models.dart';

Movie movieFromMap(String str) => Movie.fromMap(json.decode(str));

class Movie {
  Movie({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.favorite,
    this.genreIds,
  });

  bool adult;
  String backdropPath;
  BelongsToCollection belongsToCollection;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  DateTime releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  bool favorite;
  List<int> genreIds;

  factory Movie.fromMapForHome(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: 'https://image.tmdb.org/t/p/w185' + json["backdrop_path"],
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

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: 'https://image.tmdb.org/t/p/w185' + json["backdrop_path"],
        belongsToCollection:
            BelongsToCollection.fromMap(json["belongs_to_collection"]),
        budget: json["budget"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: 'https://image.tmdb.org/t/p/w185' + json["poster_path"],
        productionCompanies: List<ProductionCompany>.from(
            json["production_companies"]
                .map((x) => ProductionCompany.fromMap(x))),
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((x) => ProductionCountry.fromMap(x))),
        releaseDate: DateTime.parse(json["release_date"]),
        revenue: json["revenue"],
        runtime: json["runtime"],
        spokenLanguages: List<SpokenLanguage>.from(
            json["spoken_languages"].map((x) => SpokenLanguage.fromMap(x))),
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  factory Movie.fromMapForSqf(Map<String, dynamic> json) => Movie(
        id: json["id"],
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
        genres: json["genres"]
            .toString()
            .split(',')
            .map((e) => Genre(name: e))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "movie_id": id,
        "poster_path": posterPath,
        "release_date": releaseDate.toString(),
        "vote_count": voteCount,
        "vote_average": voteAverage,
        "genres": genres.map((x) => x.name).toList().toString(),
      };
}

class BelongsToCollection {
  BelongsToCollection({
    this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
  });

  int id;
  String name;
  String posterPath;
  String backdropPath;

  factory BelongsToCollection.fromMap(Map<String, dynamic> json) {
    if (json == null) return BelongsToCollection();
    return BelongsToCollection(
      id: json["id"],
      name: json["name"],
      posterPath: json["poster_path"],
      backdropPath: json["backdrop_path"],
    );
  }
}

class ProductionCompany {
  ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  int id;
  String logoPath;
  String name;
  String originCountry;

  factory ProductionCompany.fromMap(Map<String, dynamic> json) {
    if (json == null) return ProductionCompany();
    return ProductionCompany(
      id: json["id"],
      logoPath: json["logo_path"] == null ? null : json["logo_path"],
      name: json["name"],
      originCountry: json["origin_country"],
    );
  }
}

class ProductionCountry {
  ProductionCountry({
    this.iso31661,
    this.name,
  });

  String iso31661;
  String name;

  factory ProductionCountry.fromMap(Map<String, dynamic> json) {
    if (json == null) return ProductionCountry();
    return ProductionCountry(
      iso31661: json["iso_3166_1"],
      name: json["name"],
    );
  }
}

class SpokenLanguage {
  SpokenLanguage({
    this.englishName,
    this.iso6391,
    this.name,
  });

  String englishName;
  String iso6391;
  String name;

  factory SpokenLanguage.fromMap(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
      );
}
