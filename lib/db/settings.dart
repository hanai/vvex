import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';

Future<Database> initDatabase() async {
  return openDatabase(join(await getDatabasesPath(), 'settings.db'),
      onCreate: (db, version) {
    return db
        .execute('CREATE TABLE settings(key TEXT PRIMARY KEY, value TEXT)');
  }, version: 1);
}
