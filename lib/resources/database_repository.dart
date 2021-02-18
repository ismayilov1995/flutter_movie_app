import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepository2 {
  static DatabaseRepository2 _databaseRepository2;
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

  DatabaseRepository2._internal();

  factory DatabaseRepository2() {
    if (_databaseRepository2 == null) {
      _databaseRepository2 = DatabaseRepository2._internal();
    }
    return _databaseRepository2;
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
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_movieTable($_colID INTEGER, $_colMovieID INTEGER, $_colGenres TEXT, $_colPosterPath TEXT, $_colReleaseDate TEXT, $_colTitle TEXT, $_colVoteAvg INTEGER, $_colVoteCount INTEGER)');
  }
}
