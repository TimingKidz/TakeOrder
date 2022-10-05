import 'package:invoice_manage/features/order/data/model/order_model.dart';

import '../../../core/constants/database_constants.dart';
import '../../../core/localdatabase/local_database_helper.dart';
import '../domain/entities/order_list.dart';

class OrderLocal {
  Future<List<OrderModel>> getAllOrders() async {
    // OrderHead Insert
    final db = await LocalDatabaseHelper.db.database;
    var res = await db.rawQuery('''
      SELECT ${DatabaseConstants.orderID},
      ${DatabaseConstants.payType},
      ${DatabaseConstants.soldTo},
      ${DatabaseConstants.total},
      ${DatabaseConstants.date}
      FROM ${DatabaseConstants.orderHeadTable}
    ''');
    List<OrderModel> list = res.isNotEmpty
        ? res.map((c) {
            print(c);
            return OrderModel.fromJson(c);
          }).toList()
        : [];

    print("Total: ${list.first.total}");

    // OrderList Insert
    res = await db.rawQuery('''
      SELECT ${DatabaseConstants.orderListId},
      ${DatabaseConstants.orderHeadTable}.${DatabaseConstants.orderID},
      ${DatabaseConstants.catalogTable}.${DatabaseConstants.itemID},
      ${DatabaseConstants.itemName},
      ${DatabaseConstants.listPrice},
      ${DatabaseConstants.qty}
      FROM ${DatabaseConstants.orderHeadTable}
      JOIN ${DatabaseConstants.orderListTable} ON ${DatabaseConstants.orderListTable}.${DatabaseConstants.orderID} == ${DatabaseConstants.orderHeadTable}.${DatabaseConstants.orderID}
      JOIN ${DatabaseConstants.catalogTable} ON ${DatabaseConstants.orderListTable}.${DatabaseConstants.itemID} == ${DatabaseConstants.catalogTable}.${DatabaseConstants.itemID}
      ORDER BY ${DatabaseConstants.orderHeadTable}.${DatabaseConstants.orderID}
    ''');

    if (res.isNotEmpty) {
      res.forEach((element) {
        OrderList t = OrderList.fromJson(element);
        if (list.firstWhere((o) => o.orderID == t.orderID).list == null) {
          list.firstWhere((o) => o.orderID == t.orderID).list = [t];
        } else {
          list.firstWhere((o) => o.orderID == t.orderID).list?.add(t);
        }
      });
    }

    return list;
  }

  Future<void> addOrderHead() async {
    final db = await LocalDatabaseHelper.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery(
        "SELECT MAX(${DatabaseConstants.orderID})+1 as id FROM ${DatabaseConstants.orderHeadTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    // Insert new OrderHead
    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.orderHeadTable} (${DatabaseConstants.orderID},${DatabaseConstants.payType},${DatabaseConstants.total},${DatabaseConstants.date})"
        " VALUES (?,?,?,?)",
        [id, "Cash Sale", 0, DateTime.now().toIso8601String()]);
  }

  Future<void> clearOrder(int id) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.orderListTable,
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [id]);
  }

  Future<void> deleteOrderHead(int id) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.orderHeadTable,
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [id]);
  }

  Future<void> deleteAllOrder() async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.orderHeadTable);
    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.orderHeadTable} (${DatabaseConstants.orderID},${DatabaseConstants.payType},${DatabaseConstants.total},${DatabaseConstants.date})"
        " VALUES (?,?,?,?)",
        [0, "Cash Sale", 0, DateTime.now().toIso8601String()]);
  }

  Future<double> newItem(OrderList newItem) async {
    final db = await LocalDatabaseHelper.db.database;

    updateTime(newItem.orderID);

    double lPrice = newItem.listPrice;
    int qty = newItem.qty;

    await db.rawInsert(
        "INSERT Into ${DatabaseConstants.orderListTable} (${DatabaseConstants.orderID},${DatabaseConstants.itemID},${DatabaseConstants.listPrice},${DatabaseConstants.qty})"
        " VALUES (?,?,?,?)",
        [newItem.orderID, newItem.itemID, newItem.listPrice, newItem.qty]);

    return lPrice * qty;
  }

  Future<double> updateItem(OrderList upItem, double listPrice, int qty) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(DatabaseConstants.orderListTable,
        {DatabaseConstants.listPrice: listPrice, DatabaseConstants.qty: qty},
        where: "${DatabaseConstants.orderListId} = ?",
        whereArgs: [upItem.orderListID]);
    return listPrice * qty;
  }

  Future<double> deleteItem(OrderList delItem) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.delete(DatabaseConstants.orderListTable,
        where: "${DatabaseConstants.orderListId} = ?",
        whereArgs: [delItem.orderListID]);
    return delItem.listPrice * delItem.qty;
  }

  Future<void> updatePayType(int headID, String type) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(
        DatabaseConstants.orderHeadTable, {DatabaseConstants.payType: type},
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [headID]);
  }

  Future<void> updateSoldTo(int headID, dynamic cusID) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(
        DatabaseConstants.orderHeadTable, {DatabaseConstants.soldTo: cusID},
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [headID]);
  }

  Future<void> updateTotal(int headID, double total) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(
        DatabaseConstants.orderHeadTable, {DatabaseConstants.total: total},
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [headID]);
  }

  Future<void> updateTime(int orderID) async {
    final db = await LocalDatabaseHelper.db.database;
    await db.update(DatabaseConstants.orderHeadTable,
        {DatabaseConstants.date: DateTime.now().toIso8601String()},
        where: "${DatabaseConstants.orderID} = ?", whereArgs: [orderID]);
  }
}
