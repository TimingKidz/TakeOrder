import 'package:invoice_manage/model/customer.dart';

import 'db_provider.dart';

class CustomerDbProvider {
  CustomerDbProvider._();

  static final CustomerDbProvider db = CustomerDbProvider._();

  Future<List<Customer>> getAllCustomer() async {
    final db = await DbProvider.db.database;
    var res = await db.rawQuery("""
      SELECT *
      FROM ${DbProvider.customerTable}
      LEFT JOIN ${DbProvider.categoriesTable} ON ${DbProvider.cusCateID} == ${DbProvider.cateID}
      ORDER BY ${DbProvider.companyName} ASC
    """);
    List<Customer> list = res.isNotEmpty ? res.map((c) => Customer.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> newCus(Customer newCus) async {
    final db = await DbProvider.db.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(${DbProvider.cusID})+1 as id FROM ${DbProvider.customerTable}");
    int id = int.tryParse(table.first["id"].toString()) ?? 0;
    //insert to the table using the new id
    await db.rawInsert(
        "INSERT Into ${DbProvider.customerTable} ("
            "${DbProvider.cusID},"
            "${DbProvider.companyName},"
            "${DbProvider.cusName},"
            "${DbProvider.workNum},"
            "${DbProvider.mobileNum},"
            "${DbProvider.address},"
            "${DbProvider.cusCateID})"
            " VALUES (?,?,?,?,?,?,?)",
        [id, newCus.companyName, newCus.cusName, newCus.workNum, newCus.mobileNum, newCus.address, newCus.cusCateID]);
  }

  Future<void> updateCus(Customer oldCus, Customer upCus) async {
    final db = await DbProvider.db.database;
    await db.update(
        DbProvider.customerTable,
        {
          DbProvider.companyName: upCus.companyName,
          DbProvider.cusName: upCus.cusName,
          DbProvider.workNum: upCus.workNum,
          DbProvider.mobileNum: upCus.mobileNum,
          DbProvider.address: upCus.address,
          DbProvider.cusCateID: upCus.cusCateID
        },
        where: "${DbProvider.cusID} = ?",
        whereArgs: [oldCus.cusID]
    );
  }

  Future<void> deleteCus(Customer delCus) async {
    final db = await DbProvider.db.database;
    await db.delete(
        DbProvider.customerTable,
        where: "${DbProvider.cusID} = ?",
        whereArgs: [delCus.cusID]
    );
  }
}