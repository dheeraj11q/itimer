import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Databasehelper {
  static final _databasename = "persons.db";
  static final _databaseversion = 1;

  static final table = "my_table";

  static final columnid = "id";
  static final columnname = "name";
  static final columnage = "age";

  static Database _database;

// for making single incetance
  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

// Checking database is or not
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

//creating database path

  _initDatabase() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, _databasename);
    return await openDatabase(path,
        version: _databaseversion, onCreate: _oncreate);
  }

  // creating database
  Future _oncreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table 
    ($columnid INTEGER PRIMARY KEY,
    $columnname TEXT NOT NULL
    )
    
    ''');
  }

  //function to insert, query , update, delete

  //insert func

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // function to query all the rows
  Future<List<Map<String, dynamic>>> queryall() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // function to queryspecific
  Future<List<Map<String, dynamic>>> queryspecific(int age) async {
    Database db = await instance.database;
    var res = await db.query(table, where: "age < ?", whereArgs: [age]);
    // var res = await db.rawQuery('SELECT * FROM my_table WHERE age >?', [age]);
    return res;
  }

  // function to delete some data
  Future<int> deletedata(int id) async {
    Database db = await instance.database;
    var res = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return res;
  }

  // function to update some data
  Future<int> update(int id) async {
    Database db = await instance.database;
    var res = await db.update(table, {"name": "Jin jefferson", "age": 20},
        where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<void> databaseclear() async {
    Database db = await instance.database;

    db.delete(table);
  }
}
