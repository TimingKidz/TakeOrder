import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:invoice_manage/providers/DatabaseInitialScripts.dart';
import 'package:invoice_manage/providers/DatabaseMigrationScripts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  // Categories Table Variables
  static final categoriesTable = "Categories";
  static final cateID = "cateID";
  static final cateName = "cateName";

  // Catalog Table Variables
  static final catalogTable = "Catalog";
  static final itemID = "itemID";
  static final itemName = "itemName";
  static final itemPrice = "itemPrice";

  // Customer Table Variables
  static final customerTable = "Customer";

  // OrderHead Table Variables
  static final orderHeadTable = "OrderHead";
  static final orderID = "orderID";
  static final payType = "payType";
  static final soldTo = "soldTo";
  static final total = "total";
  static final date = "date";

  // OrderList Table Variables
  static final orderListId = "id";
  static final orderListTable = "OrderList";
  static final listPrice = "listPrice";
  static final qty = "qty";

  // Memo Table Variables
  static final memoTable = "Memo";
  static final memoID = "memoID";
  static final isMemoEdited = "isMemoEdited";
  static final memoType = "memoType";
  static final memoContent = "memoContent";
  static final memoCateID = "memoCateID";

  // MemoList Variables
  static final memoListTable = "MemoList";
  static final memoItemName = "memoItemName";
  static final memoItemPrice = "memoItemPrice";

  static final initialScripts = DatabaseInitialScript.initialScripts;
  static final migrationScripts = DatabaseMigrationScripts.migrationScripts;

  DbProvider._();

  static final DbProvider db = DbProvider._();

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
            "INSERT Into $orderHeadTable ($orderID,$payType,$total,$date)"
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
