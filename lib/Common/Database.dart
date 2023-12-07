import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskist/Models/Task.dart';

class DBProvider {
  DBProvider.load();

  static final DBProvider db = DBProvider.load();
  Database _database;

  Future<Database> get database async {
    try {
      if (_database != null) return _database;
      // if _database is null we instantiate it
      _database = await initDB();
      return _database;
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  initDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "Taskist.db");
      print("Database Path: " + path);
      return await openDatabase(path, version: 1, onOpen: (db) {},
          onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Task ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "description TEXT,"
            "creationDate TEXT,"
            "isCompleted TINYINT,"
            "isDeleted TINYINT,"
            "startTime TEXT,"
            "endTime TEXT,"
            "duration INTEGER,"
            "color TEXT,"
            "isTracking TINYINT"
            ")");
      });
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  newTask(Task newTask) async {
    try {
      final db = await database;
      //get the biggest id in the table
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Task");
      int id = table.first["id"];
      if (id == null) {
        id = 1;
      }
      //insert to the table using the new id
      var raw = await db.rawInsert(
          "INSERT Into Task (id,title,description,creationDate, isCompleted, isDeleted, startTime, endTime, duration, color, isTracking)"
          " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
          [
            id,
            newTask.Title,
            newTask.Description,
            newTask.CreationDate,
            newTask.IsCompleted,
            newTask.IsDeleted,
            newTask.StartTime,
            newTask.EndTime,
            newTask.Duration,
            newTask.Color,
            newTask.IsTracking
          ]);
      return raw;
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  updateTask(Task newTask) async {
    try {
      final db = await database;
      var res = await db.update("Task", newTask.toMap(),
          where: "id = ?", whereArgs: [newTask.Id]);
      return res;
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      final db = await database;
      var res = await db
          .query("Task", where: "isDeleted = ?", whereArgs: [0]); //0:F || 1:T
      List<Task> list =
          res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
      return list.reversed.toList();
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  Future<List<Task>> getPendingTasks() async {
    try {
      final db = await database;
      var res = await db.query("Task",
          where: "isDeleted = ? AND isCompleted = ?",
          whereArgs: [0, 0]); //0:F || 1:T
      List<Task> list =
          res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
      return list.reversed.toList();
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  Future<List<Task>> getCompletedTasks() async {
    try {
      final db = await database;
      var res = await db.query("Task",
          where: "isDeleted = ? AND isCompleted = ?",
          whereArgs: [0, 1]); //0:F || 1:T
      List<Task> list =
          res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
      return list.reversed.toList();
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  Future<List<Task>> getAllDeletedTasks() async {
    try {
      final db = await database;
      var res = await db
          .query("Task", where: "isDeleted = ?", whereArgs: [1]); //0:F || 1:T
      List<Task> list =
          res.isNotEmpty ? res.map((c) => Task.fromJson(c)).toList() : [];
      return list.reversed.toList();
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  deleteTask(int id) async {
    try {
      final db = await database;
      //print("Task deleted successfuly");
      return db.delete("Task", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

  deleteAllTask() async {
    try {
      final db = await database;
      db.delete("Task", where: "isDeleted = ?", whereArgs: [true]); //0:F || 1:T
    } catch (err) {
      print('P DB Error : ' + err.toString());
    }
  }

//  getTask(int id) async {
//    final db = await database;
//    var res = await db.query("Task", where: "id = ?", whereArgs: [id]);
//    return res.isNotEmpty ? Task.fromMap(res.first) : null;
//  }
}
