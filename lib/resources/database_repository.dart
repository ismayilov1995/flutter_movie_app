import 'dart:convert';
import 'dart:io';

import 'package:movie_app/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  static DatabaseRepository _databaseRepository;
  static Database _database;

  String _favoriteTable = 'favorites';
  String _movieTable = 'movie';
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
    final path = join(appDirectory.path, 'movie_app.db');
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_favoriteTable($_colID INTEGER PRIMARY KEY, $_colMovieID INTEGER, $_colGenres TEXT, $_colPosterPath TEXT, $_colReleaseDate TEXT, $_colTitle TEXT, $_colVoteAvg INTEGER, $_colVoteCount INTEGER)');
    await db.execute(
        'CREATE TABLE $_movieTable(id INTEGER PRIMARY KEY, movie TEXT)');
  }

  Future<bool> favoriteMovie(Movie movie) async {
    final db = await _getDb();
    if (await isFavorite(movie.id)) {
      await removeFavoritesMovie(movie.id);
      return false;
    } else {
      await db.insert(_favoriteTable, movie.toMap(), nullColumnHack: '$_colID');
      return true;
    }
  }

  Future<bool> isFavorite(int movieID) async {
    final db = await _getDb();
    var res = await db.rawQuery(
        'SELECT $_colMovieID FROM $_favoriteTable WHERE $_colMovieID=?',
        [movieID]);
    return res.length > 0;
  }

  Future<List<Movie>> getFavoritesMovie() async {
    final db = await _getDb();
    final res = await db.rawQuery('SELECT * FROM $_favoriteTable');
    return res.map((e) {
      return Movie.fromMapForSqf(e);
    }).toList();
  }

  Future<bool> removeFavoritesMovie(int movieID) async {
    final db = await _getDb();
    final res = await db
        .delete(_favoriteTable, where: '$_colMovieID=?', whereArgs: [movieID]);
    return res > 0;
  }

  Future<bool> removeAllFavorites() async {
    final db = await _getDb();
    final res = await db.delete(_favoriteTable);
    return res > 0;
  }

  Future<bool> addMovie(Movie movie) async {
    if (await isMovieStored(movie.id)) {
      return false;
    } else {
      final db = await _getDb();
      final res = await db.insert(_movieTable, movieToMapSqf(movie));
      return res > 0;
    }
  }

  Future<Movie> getMovie(int id) async {
    final db = await _getDb();
    final res =
        await db.rawQuery('SELECT * FROM $_movieTable WHERE id=?', [id]);
    return Movie.fromSqfMap(jsonDecode(res.first['movie']));
  }

  Future<bool> isMovieStored(int movieID) async {
    final db = await _getDb();
    var res =
        await db.rawQuery('SELECT id FROM $_movieTable WHERE id=?', [movieID]);
    return res.length > 0;
  }
}
