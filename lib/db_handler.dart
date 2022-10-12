import 'package:sqflite/sqflite.dart';
import 'package:sqlite_flutt/note_keep.dart';

import 'package:path/path.dart';

class DBhelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabse();
    return _db;
  }

  initDatabse() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Test.db');
    Database database =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Test (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,age INTEGER NOT NULL, desc TEXT NOT NULL, email TEXT)",
    );
  }

  Future<NodeModel> insert(NodeModel nodeModel) async {
    var dbClient = await db;
    await dbClient!.insert('Test', nodeModel.toMap());
    return nodeModel;
  }

  Future<List<NodeModel>> getNotes() async {
    var dbClient = await db;
    List<Map<String, Object?>> records = await dbClient!.query('Test');
    return records.map((e) => NodeModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('Test', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(NodeModel nodeModel) async {
    var dbClient = await db;
    return await dbClient!.update('Test', nodeModel.toMap(),
        where: 'id = ?', whereArgs: [nodeModel.id]);
  }

  Future<int> deleteTable() async {
    var dbClient = await db;
    return await dbClient!.delete('Test');
  }
}
