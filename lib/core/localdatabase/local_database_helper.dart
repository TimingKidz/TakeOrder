import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:invoice_manage/core/localdatabase/scripts/local_database_initial_scripts.dart';
import 'package:invoice_manage/core/localdatabase/scripts/local_database_migration_scripts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/database_constants.dart';

class LocalDatabaseHelper {
  static final initialScripts = DatabaseInitialScript.initialScripts;
  static final migrationScripts = DatabaseMigrationScripts.migrationScripts;

  LocalDatabaseHelper._();

  static final LocalDatabaseHelper db = LocalDatabaseHelper._();

  // For test purpose.
  Future<void> deleteDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "database.db");
    await deleteDatabase(path);
  }

  static Database? _database;

  Future<Database> get database async {
    // await deleteDb(); // For test purpose.
    return _database ??= await _init();
  }

  Future<Database> _init() async {
    String databasePath =
        await getDatabasesPath(); //returns a directory which stores permanent files
    final path = join(databasePath, "database.db"); //create path to database

    return await openDatabase(
      //open the database or create a database if there isn't any
      path,
      version: migrationScripts.length + 1,
      onCreate: (Database db, int version) async {
        initialScripts.forEach((script) async => await db.execute(script));

        await db.rawInsert(
            "INSERT Into ${DatabaseConstants.orderHeadTable} (${DatabaseConstants.orderID},${DatabaseConstants.payType},${DatabaseConstants.total},${DatabaseConstants.date})"
            " VALUES (?,?,?,?)",
            [0, "Cash Sale", 0, DateTime.now().toIso8601String()]);

        debugPrint('Finished Initial Database Table');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        db.transaction((txn) async {
          debugPrint("$oldVersion, $newVersion");
          for (var i = oldVersion - 1; i < newVersion - 1; i++) {
            migrationScripts[i].forEach((script) async {
              await txn.execute(script);
            });
            debugPrint('Migration scripts ${i + 1}');
          }
        });
      },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
        debugPrint('Configure Database Completed');
      },
    );
  }
}
