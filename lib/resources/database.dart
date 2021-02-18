import 'dart:async';
import 'dart:io' as io;
import 'package:movie_app/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  DatabaseRepository.internal();

  static final _instance = DatabaseRepository.internal();

  factory DatabaseRepository() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + '/moviefavorites.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Favorites(id INTEGER PRIMARY KEY, title TEXT, movie_id INT, poster_path BLOB, release_date TEXT, vote_count TEXT, vote_average TEXT, genres TEXT)');
  }

  insertMovie(Movie movie) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery("SELECT * FROM Favorites WHERE movie_id=?", [movie.id]);
    if (list.length == 0) {
      await dbClient.insert("Favorites", movie.toMap());
    }
  }

  Future<List<Movie>> getFavorites() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery("SELECT * FROM Favorites ORDER BY id DESC");
    List<Movie> movies = List();
    list.forEach((f) => movies.add(Movie.fromMapForSqf(f)));
    return movies;
  }

  Future<int> removeFavorite(int id) async {
    var dbClient = await db;
    return await dbClient
        .rawDelete("DELETE FROM Favorites WHERE movie_id=?", [id]);
  }

  Future<bool> updateFavorite(Movie movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Favorites", movie.toMap(),
        where: "movie_id=?", whereArgs: [movie.id]);
    return res > 0;
  }

  Future<bool> isAdded(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery("SELECT movie_id FROM Favorites WHERE movie_id=?", [id]);
    return res.length > 0;
  }
}
