    
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_assignment_03/Model/todo.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE todo ("
          "id INTEGER PRIMARY KEY autoincrement,"
          "title VARCHAR(255),"
          "done INTEGER"
          ")");
    });
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    //get the biggest id in the table
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    // int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into todo (title,done)"
        " VALUES (?,?)",
        [newTodo.title, newTodo.done]);
    return raw;
  }

  blockOrUnblock(Todo todo) async {
    final db = await database;
    Todo done = Todo(
        id: todo.id,
        title: todo.title,
        done: (todo.done==0)? 1:0);
    var res = await db.update("todo", done.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateTodo(Todo newTodo) async {
    final db = await database;
    var res = await db.update("todo", newTodo.toMap(),
        where: "id = ?", whereArgs: [newTodo.id]);
    return res;
  }

  getTodo(int id) async {
    final db = await database;
    var res = await db.query("todo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

   Future<List<Todo>> getAllCompletTodo() async {
    final db = await database;
    // var res = await db.query("Todo", where: "done = ?", whereArgs: [done]);
    var res = await db.rawQuery("SELECT * FROM todo WHERE done = 1");

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }
  
  Future<List<Todo>> getAllTaskTodo() async {
    final db = await database;
    // var res = await db.query("Todo", where: "done = ?", whereArgs: [done]);
    var res = await db.rawQuery("SELECT * FROM todo WHERE done = 0");

     List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getStatusTodo() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Todo WHERE done=1");
    var res = await db.query("todo", where: "done = ? ", whereArgs: [1]);

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    // var res = await db.query("Todo");
    var res = await db.rawQuery("SELECT * FROM todo");

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  deleteTodo(int id) async {
    print("delete");
    final db = await database;
    return db.delete("todo", where: "id = ?", whereArgs: [id]);
  }

  deleteTodoFromStatus() async {
    int done = 1;
    print("deletefromstatus");
    final db = await database;
    return db.delete("todo", where: "done = ?", whereArgs: [done]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from todo");
  }
}