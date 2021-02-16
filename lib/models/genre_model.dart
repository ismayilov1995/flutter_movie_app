class GenresModel {
  GenresModel({
    this.genres,
  });

  List<Genre> genres;

  factory GenresModel.fromMap(Map<String, dynamic> json) => GenresModel(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
      );

  String getGenreTitle(List<int> genreIds) {
    String titledGenres = "";
    genreIds.forEach((e) =>
        titledGenres += genres.where((g) => g.id == e).first.name + ", ");
    titledGenres = titledGenres.substring(0, titledGenres.length - 2);
    return titledGenres;
  }
}

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Genre.fromMap(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
