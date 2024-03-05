import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';


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
    final path = join(await getDatabasesPath(), "plants.db");
    final exists = await databaseExists(path);
    _path = path;
    //print(path);

    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets/", "plants.db"));
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
