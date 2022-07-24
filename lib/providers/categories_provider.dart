import 'package:invoice_manage/core/constants/database_constants.dart';
import 'package:invoice_manage/model/catagories.dart';

import '../core/localdatabase/local_database_helper.dart';

class CateDbProvider {
  CateDbProvider._();

  static final CateDbProvider db = CateDbProvider._();

  Future<List<Categories>> getAllCategories() async {
    final db = await LocalDatabaseHelper.db.database;
    var res = await db.query(DatabaseConstants.categoriesTable);
    List<Categories> list =
        res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newCate(Categories newCate) async {
    final db = await LocalDatabaseHelper.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery(
        "SELECT MAX(${DatabaseConstants.cateID})+1 as id FROM ${DatabaseConstants.categoriesTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.categoriesTable} ("
        "${DatabaseConstants.cateID},"
        "${DatabaseConstants.cateName})"
        " VALUES (?,?)",
        [id, newCate.cateName]);
  }

  Future<void> updateCate(Categories old, Categories up) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(DatabaseConstants.categoriesTable,
        {DatabaseConstants.cateName: up.cateName},
        where: "${DatabaseConstants.cateID} = ?", whereArgs: [old.cateID]);
  }

  Future<void> deleteCate(Categories del) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.categoriesTable,
        where: "${DatabaseConstants.cateID} = ?", whereArgs: [del.cateID]);
  }
}
