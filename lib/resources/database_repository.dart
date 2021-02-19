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
    await db.execute('CREATE TABLE $_favoriteTable(id INTEGER PRIMARY KEY)');
    await db.execute(
        'CREATE TABLE $_movieTable(id INTEGER PRIMARY KEY, movie TEXT)');
  }

  Future<bool> favoriteMovie(int id) async {
    final db = await _getDb();
    if (await isFavorite(id)) {
      await removeFavoritesMovie(id);
      return false;
    } else {
      await db.insert(_favoriteTable, {'id': id}, nullColumnHack: 'id');
      return true;
    }
  }

  Future<bool> isFavorite(int movieID) async {
    final db = await _getDb();
    var res = await db
        .rawQuery('SELECT id FROM $_favoriteTable WHERE id=?', [movieID]);
    return res.length > 0;
  }

  Future<List<Movie>> getFavoritesMovie() async {
    final db = await _getDb();
    List<Movie> movies;
    final res = await db.rawQuery('SELECT * FROM $_favoriteTable');
    res.map((e) async => movies.add(await getMovie(e['id'])));
    return movies;
  }

  Future<bool> removeFavoritesMovie(int movieID) async {
    final db = await _getDb();
    final res =
        await db.delete(_favoriteTable, where: 'id=?', whereArgs: [movieID]);
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
