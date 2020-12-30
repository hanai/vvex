import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  return openDatabase(join(await getDatabasesPath(), 'cache.db'),
      onCreate: (db, version) {
    return db.execute('''
      CREATE TABLE topic_cache(id INTEGER PRIMARY KEY, value TEXT);
      CREATE TABLE reply_cache(id INTEGER PRIMARY KEY, value TEXT);
      ''');
  }, version: 1);
}
