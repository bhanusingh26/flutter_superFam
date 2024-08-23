import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tableName = "NewKeyValueTable";
  final String _tableId = "id";
  final String _tableKey = "key";
  final String _tableValue = "value";

  DatabaseService._constructor();

  /// Get method to fetch database
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  /// To create database/table
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $_tableName ($_tableId INTEGER PRIMARY KEY, $_tableValue TEXT, $_tableKey TEXT)');
      },
    );
    return database;
  }

  /// To add into database
  void addTask({required String value, required String key}) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        _tableKey: key,
        _tableValue: value,
      },
    );
  }

  /// To fetch from database
  Future<List<Task>> getTasks() async {
    final db = await database;
    final data = await db.query(_tableName);
    List<Task> tasks = data
        .map(
          (e) => Task(
            id: e["id"] as int,
            key: e["key"] as String,
            value: e["value"] as String,
          ),
        )
        .toList();
    return tasks;
  }
}
