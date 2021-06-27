import 'package:invoice_manage/model/item.dart';

import 'db_provider.dart';

class CatalogDbProvider {
  CatalogDbProvider._();

  static final CatalogDbProvider db = CatalogDbProvider._();

  Future<List<Item>> getAllCatalog() async {
    final db = await DbProvider.db.database;
    var res = await db.query(DbProvider.catalogTable, orderBy: DbProvider.itemName);
    List<Item> list = res.isNotEmpty ? res.map((c) => Item.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newItem(Item newItem) async {
    final db = await DbProvider.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(${DbProvider.itemID})+1 as id FROM ${DbProvider.catalogTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DbProvider.catalogTable} (${DbProvider.itemID},${DbProvider.itemName},${DbProvider.itemPrice})"
            " VALUES (?,?,?)",
        [id, newItem.itemName, newItem.itemPrice]);
  }

  Future<void> updateItem(Item oldItem, Item upItem) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.catalogTable,
        {DbProvider.itemName: upItem.itemName, DbProvider.itemPrice: upItem.itemPrice},
        where: "${DbProvider.itemID} = ?",
        whereArgs: [oldItem.itemID]
    );
  }

  Future<void> deleteItem(Item delItem) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.catalogTable,
        where: "${DbProvider.itemID} = ?",
        whereArgs: [delItem.itemID]
    );
  }
}