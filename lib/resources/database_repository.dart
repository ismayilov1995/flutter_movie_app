import 'dart:io';

import 'package:movie_app/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  static DatabaseRepository _databaseRepository;
  static Database _database;

  String _movieTable = 'favorites';
  String _colID = 'id';
  String _colTitle = 'title';
  String _colMovieID = 'movie_id';
  String _colPosterPath = 'poster_path';
  String _colReleaseDate = 'release_date';
  String _colVoteCount = 'vote_count';
  String _colVoteAvg = 'vote_average';
  String _colGenres = 'genres';

  DatabaseRepository._internal();

  factory DatabaseRepository() {
    if (_databaseRepository == null) {
      _databaseRepository = DatabaseRepository._internal();
    }
    return _databaseRepository;
  }

  Future<Database> _getDb() async {
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database;
  }

  Future<Database> _initializeDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    final path = join(appDirectory.path, 'favorites.db');
    print(path);
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_movieTable($_colID INTEGER PRIMARY KEY, $_colMovieID INTEGER, $_colGenres TEXT, $_colPosterPath TEXT, $_colReleaseDate TEXT, $_colTitle TEXT, $_colVoteAvg INTEGER, $_colVoteCount INTEGER)');
  }

  Future<int> favoriteMovie(Movie movie) async {
    final db = await _getDb();
    if (await isFavorite(movie.id)) {
      return 0;
    } else {
      return await db.insert(_movieTable, movie.toMap(),
          nullColumnHack: '$_colID');
    }
  }

  Future<bool> isFavorite(int movieID) async {
    final db = await _getDb();
    var res = await db.rawQuery(
        'SELECT $_colMovieID FROM $_movieTable WHERE $_colMovieID=?',
        [movieID]);
    return res.length > 0;
  }

  Future<List<Movie>> getFavoritesMovie() async {
    final db = await _getDb();
    final res = await db.rawQuery('SELECT * FROM $_movieTable');
    return res.map((e) {
      return Movie.fromMapForSqf(e);
    }).toList();
  }

  Future<bool> removeFavoritesMovie(int movieID) async {
    final db = await _getDb();
    final res = await db
        .delete(_movieTable, where: '$_colMovieID=?', whereArgs: [movieID]);
    return res > 0;
  }

  Future<bool> removeAllFavorites() async {
    final db = await _getDb();
    final res = await db.delete(_movieTable);
    return res > 0;
  }
}
