import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sukke/constants.dart';

class DBService {

  // Singleton pattern
  static final DBService _instance = DBService._privateConstructor();
  DBService._privateConstructor();
  factory DBService() => _instance;

  // Members
  Database? _database;
  String? _path;

  String? path() => _path;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }

    // if _database is null we instantiate it
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), dbName);
    final exists = await databaseExists(path);
    _path = path;

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join(assetsFolder, dbName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } /*else {
      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets/", "plants.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }*/

    return await openDatabase(path);
  }
}

Future<int> getMaxId(String object) async {
  final db = await DBService().db;

  // Get high-water-mark id and cross check with current max to create some
  // self-correcting logic.
  final query = '''
  SELECT MAX(s.[valueNum], m.[id]) AS 'maxId'
  FROM [System] AS s
  JOIN [Metadata] AS m
  ON s.[key] = m.[object]
  WHERE s.[key] = ?1;
  ''';

  final map = await db.rawQuery(query, [object]);
  return map[0]['maxId'] as int;
}

