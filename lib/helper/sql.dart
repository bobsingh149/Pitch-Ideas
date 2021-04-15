import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class Sql {
  static Future<sql.Database> getdatabase(String table) async {
    final basedir = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(basedir, 'databasename.db'), version: 1,
        onCreate: (db, ver) {
      db.execute('CREATE TABLE Users (id INTEGER, title TEXT, img TEXT)');
    });
  }

  static Future<void> storedata(String table, Map<String, Object> data) async {
    sql.Database mydatabase = await Sql.getdatabase(table);

    mydatabase.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> fetchdata(String table) async {
    sql.Database mydatabase = await Sql.getdatabase(table);

    return mydatabase.query(table);
  }

  static Future<int> delete(String table, String title) async {
    sql.Database mydatbase = await Sql.getdatabase(table);
    
    return mydatbase.delete(
      table,
      where: 'title = ?',
      whereArgs: [title],
    
    );
  }
}
