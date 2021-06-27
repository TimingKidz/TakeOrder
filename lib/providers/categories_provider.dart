import 'package:invoice_manage/model/catagories.dart';

import 'db_provider.dart';

class CateDbProvider {
  CateDbProvider._();

  static final CateDbProvider db = CateDbProvider._();

  Future<List<Categories>> getAllCategories() async {
    final db = await DbProvider.db.database;
    var res = await db.query(DbProvider.categoriesTable);
    List<Categories> list = res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newCate(Categories newCate) async {
    final db = await DbProvider.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(${DbProvider.cateID})+1 as id FROM ${DbProvider.categoriesTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DbProvider.categoriesTable} ("
            "${DbProvider.cateID},"
            "${DbProvider.cateName})"
            " VALUES (?,?)",
        [id, newCate.cateName]);
  }

  Future<void> updateCate(Categories old, Categories up) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.categoriesTable,
        {
          DbProvider.cateName: up.cateName
        },
        where: "${DbProvider.cateID} = ?",
        whereArgs: [old.cateID]
    );
  }

  Future<void> deleteCate(Categories del) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.categoriesTable,
        where: "${DbProvider.cateID} = ?",
        whereArgs: [del.cateID]
    );
  }
}