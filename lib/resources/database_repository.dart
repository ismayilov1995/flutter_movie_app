import 'package:sqflite/sqflite.dart';

class DatabaseRepository2 {
  static DatabaseRepository2 _databaseRepository2;

  DatabaseRepository2._internal();

  factory DatabaseRepository2() {
    if (_databaseRepository2 == null) {
      _databaseRepository2 = DatabaseRepository2._internal();
      return _databaseRepository2;
    }
    return _databaseRepository2;
  }
}
