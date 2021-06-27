import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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
  static final cusID = "cusID";
  static final companyName = "companyName";
  static final cusName = "cusName";
  static final workNum = "workNum";
  static final mobileNum = "mobileNum";
  static final address = "address";
  static final cusCateID = "cusCateID";

  // OrderHead Table Variables
  static final orderHeadTable = "OrderHead";
  static final orderID = "orderID";
  static final payType = "payType";
  static final soldTo = "soldTo";
  static final total = "total";
  static final date = "date";

  // OrderList Table Variables
  static final orderListTable = "OrderList";
  static final listPrice = "listPrice";
  static final qty = "qty";

  // Memo Table Variables
  static final memoTable = "Memo";
  static final memoID = "memoID";
  static final memoTitle = "memoTitle";
  static final memoType = "memoType";
  static final memoContent = "memoContent";
  static final memoCateID = "memoCateID";

  // MemoList Variables
  static final memoListTable = "MemoList";
  static final memoItemName = "memoItemName";
  static final memoItemPrice = "memoItemPrice";

  DbProvider._();

  static final DbProvider db = DbProvider._();

  Future<void> deleteDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,"database.db");
    await deleteDatabase(path);
  }

  static Database? _database;
  Future<Database> get database async {
    // await deleteDb();
    return _database ??= await _init();
  }

  Future<Database> _init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"database.db"); //create path to database

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async {
          await db.execute("""
          CREATE TABLE $categoriesTable (
            $cateID	INTEGER NOT NULL,
            $cateName TEXT NOT NULL UNIQUE,
            PRIMARY KEY($cateID)
          );
          """);

          await db.execute("""
          CREATE TABLE $catalogTable (
            $itemID	INTEGER NOT NULL,
            $itemName TEXT NOT NULL UNIQUE,
            $itemPrice REAL NOT NULL,
            PRIMARY KEY($itemID)
          );
          """);

          await db.execute("""
          CREATE TABLE $customerTable (
            $cusID	INTEGER NOT NULL,
            $companyName	TEXT,
            $cusName	TEXT,
            $workNum	VARCHAR(10),
            $mobileNum	VARCHAR(10),
            $address	TEXT,
            $cusCateID	INTEGER,
            FOREIGN KEY($cusCateID) REFERENCES $categoriesTable($cateID) ON DELETE SET NULL,
            PRIMARY KEY($cusID)
          );
          """);

          await db.execute("""
          CREATE TABLE $orderHeadTable (
            $orderID	INTEGER NOT NULL,
            $payType	TEXT NOT NULL,
            $soldTo	INTEGER,
            $total	REAL NOT NULL,
            $date TEXT NOT NULL,
            PRIMARY KEY($orderID),
            FOREIGN KEY($soldTo) REFERENCES $customerTable($cusID) ON DELETE CASCADE
          );
          """);

          await db.execute("""
          CREATE TABLE $orderListTable (
            $orderID	INTEGER NOT NULL,
            $itemID	INTEGER NOT NULL,
            $listPrice	REAL NOT NULL,
            $qty	INTEGER NOT NULL,
            FOREIGN KEY($orderID) REFERENCES $orderHeadTable($orderID) ON DELETE CASCADE,
            FOREIGN KEY($itemID) REFERENCES $catalogTable($itemID) ON DELETE CASCADE
          );
          """);

          await db.execute("""
          CREATE TABLE $memoTable (
            $memoID	INTEGER NOT NULL,
            $memoTitle	TEXT,
            $memoContent	TEXT,
            $memoCateID	INTEGER,
            FOREIGN KEY($memoCateID) REFERENCES $categoriesTable($cateID) ON DELETE SET NULL,
            PRIMARY KEY($memoID)
          );
          """);

          // await db.execute("""
          // CREATE TABLE $memoListTable (
          //   $memoID	INTEGER NOT NULL,
          //   $memoItemName	TEXT NOT NULL,
          //   $memoItemPrice	REAL NOT NULL,
          //   FOREIGN KEY($memoID) REFERENCES $memoListTable($memoID) ON DELETE CASCADE
          // );
          // """);

          await db.rawInsert(
              "INSERT Into $orderHeadTable ($orderID,$payType,$total,$date)"
                  " VALUES (?,?,?,?)",
              [0, "Cash Sale", 0, DateTime.now().toIso8601String()]);

          debugPrint('Finished Initial Database Table');
        },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
        debugPrint('Configure Database Completed');
      },
    );
  }
}