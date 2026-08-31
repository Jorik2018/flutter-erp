import 'package:flutter/foundation.dart';
import 'package:flutter_erp/apps/flutter_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _db;

  DatabaseHelper._instance();

  static const String tasksTable = 'task_table';

  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colDate = 'date';
  static const String colPriority = 'priority';
  static const String colStatus = 'status';
  static const String colIsDone = 'isDone';
  static const String colUserId = 'userId';

  Future<Database> get db async {
    return _db ??= await _initDb();
  }

  Future<Database> _initDb() async {
    late String path;

    if (kIsWeb) {
      // SQLite Web -> WASM + IndexedDB
      databaseFactory = databaseFactoryFfiWeb;

      path = 'todo_list.db';
    } else {
      // Android / iOS / macOS
      final databasesPath = await getDatabasesPath();

      path = '$databasesPath/todo_list.db';
    }

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tasksTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colContent TEXT,
        $colDate TEXT,
        $colPriority TEXT,
        $colStatus INTEGER,
        $colIsDone INTEGER NOT NULL DEFAULT 0,
        $colUserId TEXT
      )
    ''');
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tasksTable ADD COLUMN $colContent TEXT');

      await db.execute(
        'ALTER TABLE $tasksTable '
        'ADD COLUMN $colIsDone INTEGER NOT NULL DEFAULT 0',
      );

      await db.execute('ALTER TABLE $tasksTable ADD COLUMN $colUserId TEXT');
    }
  }

  Future<int> insertTask(Task task) async {
    final database = await db;

    final data = task.toMap();

    data['isDone'] = task.isDone ? 1 : 0;

    return database.insert(tasksTable, data);
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    final database = await db;

    return database.query(tasksTable);
  }

  Future<List<Task>> getTaskList() async {
    final taskMapList = await getTaskMapList();

    final taskList = taskMapList.map(Task.fromMap).toList();

    taskList.sort((taskA, taskB) {
      final a = taskA.date;
      final b = taskB.date;

      if (a == null && b == null) {
        return 0;
      }

      if (a == null) {
        return 1;
      }

      if (b == null) {
        return -1;
      }

      return a.compareTo(b);
    });

    return taskList;
  }

  Future<int> updateTask(Task task) async {
    final database = await db;

    return database.update(
      tasksTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final database = await db;

    return database.delete(tasksTable, where: '$colId = ?', whereArgs: [id]);
  }
}
