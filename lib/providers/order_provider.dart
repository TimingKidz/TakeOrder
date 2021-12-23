import 'package:invoice_manage/model/order.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/providers/db_provider.dart';

class OrderDbProvider {
  OrderDbProvider._();

  static final OrderDbProvider db = OrderDbProvider._();

  Future<List<Order>> getAllOrders() async {
    // OrderHead Insert
    final db = await DbProvider.db.database;
    var res = await db.rawQuery('''
      SELECT ${DbProvider.orderID},
      ${DbProvider.payType},
      ${DbProvider.soldTo},
      ${DbProvider.total},
      ${DbProvider.date}
      FROM ${DbProvider.orderHeadTable}
    ''');
    List<Order> list = res.isNotEmpty ? res.map((c) => Order.fromMap(c)).toList() : [];

    // OrderList Insert
    res = await db.rawQuery('''
      SELECT ${DbProvider.orderListId},
      ${DbProvider.orderHeadTable}.${DbProvider.orderID},
      ${DbProvider.catalogTable}.${DbProvider.itemID},
      ${DbProvider.itemName},
      ${DbProvider.listPrice},
      ${DbProvider.qty}
      FROM ${DbProvider.orderHeadTable}
      JOIN ${DbProvider.orderListTable} ON ${DbProvider.orderListTable}.${DbProvider.orderID} == ${DbProvider.orderHeadTable}.${DbProvider.orderID}
      JOIN ${DbProvider.catalogTable} ON ${DbProvider.orderListTable}.${DbProvider.itemID} == ${DbProvider.catalogTable}.${DbProvider.itemID}
      ORDER BY ${DbProvider.orderHeadTable}.${DbProvider.orderID}
    ''');

    if (res.isNotEmpty) {
      res.forEach((element) {
        OrderList t = OrderList.fromMap(element);
        list.firstWhere((o) => o.orderID == t.orderID).list.add(t);
      });
    }

    return list;
  }

  Future<List<dynamic>> getSummary() async {
    final db = await DbProvider.db.database;
    var itemTotal = await db.rawQuery("""
      SELECT SUM(${DbProvider.qty}) as qty, ${DbProvider.catalogTable}.${DbProvider.itemName}, SUM(${DbProvider.listPrice} * ${DbProvider.qty}) as SubTotal
      FROM ${DbProvider.orderListTable}
      JOIN ${DbProvider.catalogTable} ON ${DbProvider.orderListTable}.${DbProvider.itemID} == ${DbProvider.catalogTable}.${DbProvider.itemID}
      GROUP BY ${DbProvider.orderListTable}.${DbProvider.itemID}
    """);
    var total = await db.rawQuery("""
      SELECT SUM(${DbProvider.total}) as Total
      FROM ${DbProvider.orderHeadTable}
    """);
    var payTypeTotal = await db.rawQuery("""
      SELECT ${DbProvider.payType}, SUM(${DbProvider.total}) as TypeTotal
      FROM ${DbProvider.orderHeadTable}
      GROUP BY ${DbProvider.payType}
    """);

    Map<String, dynamic> payTypeTotalMap = {};
    payTypeTotal.forEach((Map<String, dynamic> each) {
      payTypeTotalMap.addAll({each["payType"]: each["TypeTotal"]});
    });
    return [itemTotal, total.first["Total"], payTypeTotalMap];
  }

  Future<void> addOrderHead() async {
    final db = await DbProvider.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(${DbProvider.orderID})+1 as id FROM ${DbProvider.orderHeadTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    // Insert new OrderHead
    await db.rawInsert(
        "INSERT Into ${DbProvider.orderHeadTable} (${DbProvider.orderID},${DbProvider.payType},${DbProvider.total},${DbProvider.date})"
            " VALUES (?,?,?,?)",
        [id, "Cash Sale", 0, DateTime.now().toIso8601String()]);
  }

  Future<void> clearOrder(int id) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.orderListTable,
        where: "${DbProvider.orderID} = ?",
        whereArgs: [id]
    );
  }

  Future<void> deleteOrderHead(int id) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.orderHeadTable,
        where: "${DbProvider.orderID} = ?",
        whereArgs: [id]
    );
  }

  Future<void> deleteAllOrder() async {
    final db = await DbProvider.db.database;
    await db.delete(DbProvider.orderHeadTable);
    await db.rawInsert(
        "INSERT Into ${DbProvider.orderHeadTable} (${DbProvider.orderID},${DbProvider.payType},${DbProvider.total},${DbProvider.date})"
            " VALUES (?,?,?,?)",
        [0, "Cash Sale", 0, DateTime.now().toIso8601String()]);
  }

  Future<double> newItem(OrderList newItem) async {
    final db = await DbProvider.db.database;

    updateTime(newItem.orderID);

    double lPrice = newItem.listPrice;
    int qty = newItem.qty;

    await db.rawInsert(
        "INSERT Into ${DbProvider.orderListTable} (${DbProvider.orderID},${DbProvider.itemID},${DbProvider.listPrice},${DbProvider.qty})"
        " VALUES (?,?,?,?)",
        [newItem.orderID, newItem.itemID, newItem.listPrice, newItem.qty]);

    return lPrice * qty;
  }

  Future<double> updateItem(OrderList upItem, double listPrice, int qty) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.orderListTable,
        {DbProvider.listPrice: listPrice, DbProvider.qty: qty},
        where: "${DbProvider.orderListId} = ?",
        whereArgs: [upItem.orderListID]);
    return listPrice * qty;
  }

  Future<double> deleteItem(OrderList delItem) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.orderListTable,
        where: "${DbProvider.orderListId} = ?",
        whereArgs: [delItem.orderListID]);
    return delItem.listPrice * delItem.qty;
  }

  Future<void> updatePayType(int headID, String type) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.orderHeadTable,
        {DbProvider.payType: type},
        where: "${DbProvider.orderID} = ?",
        whereArgs: [headID]
    );
  }

  Future<void> updateSoldTo(int headID, dynamic cusID) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.orderHeadTable,
        {DbProvider.soldTo: cusID},
        where: "${DbProvider.orderID} = ?",
        whereArgs: [headID]
    );
  }

  Future<void> updateTotal(int headID, double total) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.orderHeadTable,
        {DbProvider.total: total},
        where: "${DbProvider.orderID} = ?",
        whereArgs: [headID]
    );
  }

  Future<void> updateTime(int orderID) async {
    final db = await DbProvider.db.database;
    await db.update(
      DbProvider.orderHeadTable,
      {DbProvider.date: DateTime.now().toIso8601String()},
      where: "${DbProvider.orderID} = ?",
      whereArgs: [orderID]
    );
  }
}