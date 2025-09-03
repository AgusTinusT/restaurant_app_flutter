import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorites = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restaurant_app.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tblFavorites (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
        debugPrint('DatabaseHelper: Table $_tblFavorites created.');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    try {
      await db?.insert(
        _tblFavorites,
        restaurant.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('DatabaseHelper: Inserted favorite: ${restaurant.id}');
    } catch (e) {
      debugPrint('DatabaseHelper: Error inserting favorite: $e');
    }
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorites);
    debugPrint('DatabaseHelper: Fetched ${results.length} favorites.');
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map<String, dynamic>> getFavoriteById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint(
      'DatabaseHelper: Fetched favorite by ID $id: ${results.isNotEmpty}',
    );
    return results.isNotEmpty ? results.first : {};
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    try {
      await db!.delete(_tblFavorites, where: 'id = ?', whereArgs: [id]);
      debugPrint('DatabaseHelper: Removed favorite: $id');
    } catch (e) {
      debugPrint('DatabaseHelper: Error removing favorite: $e');
    }
  }

  Future<void> clearFavorites() async {
    final db = await database;
    try {
      await db!.delete(_tblFavorites);
      debugPrint('DatabaseHelper: Cleared all favorites.');
    } catch (e) {
      debugPrint('DatabaseHelper: Error clearing favorites: $e');
    }
  }
}
