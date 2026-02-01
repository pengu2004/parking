import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';




class DatabaseHelper {

  //defining the database variable
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;


  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await openDatabase(
        join(await getDatabasesPath(), 'User.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          vehicleType TEXT
        )''');
        }
    );
    return _db!;
  }

static Future<void> insertUser(String name,String vehicleType) async {
final db= await database;
await db.insert('users', {'name':name,'vehicleType':vehicleType});
print(name);
}


}
