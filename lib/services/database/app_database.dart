// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:expense_app/models/dtos/base.dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  AppDatabase._() {
    // Preventing the objects to be created.
  }

  static Future<void> initDatabase() async {
    if (_db == null) {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'expenses.db');
      _db = await openDatabase(path, version: 2, onCreate: _onDatabaseCreate);
    }
  }

  static void closeDatabase() {
    if (_db != null) {
      _db!.close();
    }
  }

  static FutureOr<void> _onDatabaseCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE User (
            Id INTEGER PRIMARY KEY AUTOINCREMENT, 
            Name TEXT, 
            Username TEXT, 
            Password TEXT, 
            CreatedOn DATETIME DEFAULT CURRENT_TIMESTAMP,
            UpdatedOn DATETIME DEFAULT CURRENT_TIMESTAMP
          )
      ''');

    await db.execute('''CREATE TABLE Expense (
            Id INTEGER PRIMARY KEY AUTOINCREMENT, 
            Name TEXT, 
            ExpenseDate DATETIME, 
            Amount FLOAT, 
            CategoryId INTEGER, 
            Note TEXT,
            CreatedOn DATETIME,
            UpdatedOn DATETIME,
            IsDeleted BOOLEAN DEFAULT 0
          )''');

    await db.execute('''
      CREATE TABLE ExpenseCategory
      (
        Id INTEGER PRIMARY KEY AUTOINCREMENT, 
        Name TEXT, 
        IconPoint INTEGER,
        CreatedOn DATETIME,
        UpdatedOn DATETIME
      )
''');

    await db.execute('''
      INSERT INTO ExpenseCategory(Name, IconPoint, CreatedOn, UpdatedOn)
      VALUES 
      ('Groceries', 58775, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
      ('Emergency', 57400, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
      ('Investments', 57408, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
      ('Fitness', 57891, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
      ('Bills', 58348, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''');
  }

  static Future<int> insert<T extends BaseDTO>(T obj) async {
    if (_db != null) {
      return _db!.insert(obj.getTableName(), obj.toMap());
    }

    return 0;
  }

  static Future<bool> update<T extends BaseDTO>(T data, {String? whereQuery}) async {
    if (_db != null) {
      return (await _db!.update(data.getTableName(), data.toMap(), where: whereQuery)) > 0;
    }

    return false;
  }

  static Future<List<Map<String, Object?>>>? get(String tableName, {String? where}) {
    if (_db != null) {
      return _db!.query(tableName, where: where);
    }

    return null;
  }

  static Future<bool> delete(String tableName, {String? where}) async {
    if (_db != null) {
      return (await _db!.delete(tableName, where: where)) > 0;
    }

    return false;
  }

  static Future<bool> exists(String tableName, {String? where}) async {
    if (_db != null) {
      var result = await _db!.query(tableName, where: where);
      return result != null && result.isNotEmpty;
    }

    return false;
  }
}
