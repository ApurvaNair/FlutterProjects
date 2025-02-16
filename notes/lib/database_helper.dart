import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notes/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper = DatabaseHelper.createInstance();
  static late Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colContent = 'content';
  String colModifiedTime = 'modifiedTime';
  String colPriority = 'priority';

  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    return databaseHelper;
  }

  Future<Database> get database async {
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colContent TEXT, $colModifiedTime DATETIME, $colPriority TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;
    var result =
        await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }
}
