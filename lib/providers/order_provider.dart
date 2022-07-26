import 'package:invoice_manage/core/localdatabase/local_database_helper.dart';
import 'package:invoice_manage/model/order.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/model/order_item.dart';

import '../core/constants/database_constants.dart';
import '../features/summary/domain/entities/summary.dart';

class OrderDbProvider {
  OrderDbProvider._();

  static final OrderDbProvider db = OrderDbProvider._();

  Future<List<Order>> getAllOrders() async {
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
    List<Order> list =
    res.isNotEmpty ? res.map((c) => Order.fromMap(c)).toList() : [];

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
        OrderList t = OrderList.fromMap(element);
        list.firstWhere((o) => o.orderID == t.orderID).list.add(t);
      });
    }

    return list;
  }

  Future<Summary> getSummary() async {
    final db = await LocalDatabaseHelper.db.database;
    var itemTotal = await db.rawQuery("""
      SELECT SUM(${DatabaseConstants.qty}) as qty, ${DatabaseConstants.catalogTable}.${DatabaseConstants.itemName}, SUM(${DatabaseConstants.listPrice} * ${DatabaseConstants.qty}) as SubTotal
      FROM ${DatabaseConstants.orderListTable}
      JOIN ${DatabaseConstants.catalogTable} ON ${DatabaseConstants.orderListTable}.${DatabaseConstants.itemID} == ${DatabaseConstants.catalogTable}.${DatabaseConstants.itemID}
      GROUP BY ${DatabaseConstants.orderListTable}.${DatabaseConstants.itemID}
    """);
    var total = await db.rawQuery("""
      SELECT SUM(${DatabaseConstants.total}) as Total
      FROM ${DatabaseConstants.orderHeadTable}
    """);
    var payTypeTotal = await db.rawQuery("""
      SELECT ${DatabaseConstants.payType}, SUM(${DatabaseConstants.total}) as TypeTotal
      FROM ${DatabaseConstants.orderHeadTable}
      GROUP BY ${DatabaseConstants.payType}
    """);

    Map<String, dynamic> payTypeTotalMap = {};
    payTypeTotal.forEach((Map<String, dynamic> each) {
      payTypeTotalMap.addAll({each["payType"]: each["TypeTotal"]});
    });

    List<OrderItem> allItems = itemTotal
        .map((Map<String, Object?> object) => OrderItem.fromJson(object))
        .toList();

    return Summary(
        orderItemList: allItems,
        totals: double.parse(total.first["Total"].toString()),
        payTypeTotalMap: payTypeTotalMap);
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
