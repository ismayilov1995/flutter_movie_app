class GenresModel {
  GenresModel({
    this.genres,
  });

  List<Genre> genres;

  factory GenresModel.fromMap(Map<String, dynamic> json) => GenresModel(
    genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
  );

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
