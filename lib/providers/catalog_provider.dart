import 'package:invoice_manage/model/item.dart';

import '../core/constants/database_constants.dart';
import '../core/local_database_helper.dart';

class CatalogDbProvider {
  CatalogDbProvider._();

  static final CatalogDbProvider db = CatalogDbProvider._();

  Future<List<Item>> getAllCatalog() async {
    final db = await LocalDatabaseHelper.db.database;
    var res = await db.query(DatabaseConstants.catalogTable,
        orderBy: DatabaseConstants.itemName);
    List<Item> list =
        res.isNotEmpty ? res.map((c) => Item.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newItem(Item newItem) async {
    final db = await LocalDatabaseHelper.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery(
        "SELECT MAX(${DatabaseConstants.itemID})+1 as id FROM ${DatabaseConstants.catalogTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.catalogTable} (${DatabaseConstants.itemID},${DatabaseConstants.itemName},${DatabaseConstants.itemPrice})"
        " VALUES (?,?,?)",
        [id, newItem.itemName, newItem.itemPrice]);
  }

  Future<void> updateItem(Item oldItem, Item upItem) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(
        DatabaseConstants.catalogTable,
        {
          DatabaseConstants.itemName: upItem.itemName,
          DatabaseConstants.itemPrice: upItem.itemPrice
        },
        where: "${DatabaseConstants.itemID} = ?",
        whereArgs: [oldItem.itemID]);
  }

  Future<void> deleteItem(Item delItem) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.catalogTable,
        where: "${DatabaseConstants.itemID} = ?", whereArgs: [delItem.itemID]);
  }
}
