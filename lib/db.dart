import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sukke/constants.dart';

class DBService {

  // Singleton pattern
  static final DBService _instance = DBService._privateConstructor();
  DBService._privateConstructor();
  factory DBService() => _instance;

  // Members
  Database? _database;
  String? _path;

  Completer<Database>? _dbOpenCompleter;

  String? path() => _path;

  Future<Database> get db async {
    // If _database was closed or never opened, it will be null
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    // If already opening, wait for that future to complete
    if (_dbOpenCompleter != null && !_dbOpenCompleter!.isCompleted) {
      return _dbOpenCompleter!.future;
    }

    _dbOpenCompleter = Completer<Database>();

    try {
      _database = await _initDB();
      _dbOpenCompleter!.complete(_database);
    } catch (e) {
      _dbOpenCompleter!.completeError(e);
      rethrow;
    }

    return _database!;
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      // Reset the reference to null so 'get db' knows to re-init
      _database = null;
      _dbOpenCompleter = null;
    }
  }

  Future<Database> _initDB() async {
    final dbPath = join(await getDatabasesPath(), dbName);
    final exists = await databaseExists(dbPath);
    _path = dbPath;

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
      } catch (_) {}

      try {
        // Copy from asset
        ByteData data = await rootBundle.load(url.join(assetsFolder, dbName));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(dbPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        throw Exception("Failed to copy initial database: $e");
      }
    }

    return await openDatabase(dbPath);
  }
}

Future<int> getMaxId(String object) async {
  final db = await DBService().db;

  // Get high-water-mark id and cross check with current max to create some
  // self-correcting logic.
  final query = '''
  SELECT MAX(s.[valueNum], m.[id]) AS 'maxId'
  FROM [System] AS s
  LEFT JOIN [Metadata] AS m ON s.[key] = m.[object]
  WHERE s.[key] = ?1;
  ''';

  final List<Map<String, dynamic>> results = await db.rawQuery(query, [object]);
  if (results.isNotEmpty && results.first['maxId'] != null) {
    return results.first['maxId'] as int;
  }
  return 0;
}

