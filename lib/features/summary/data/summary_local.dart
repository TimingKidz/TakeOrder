import 'package:invoice_manage/features/summary/data/model/summary_response.dart';

import '../../../core/constants/database_constants.dart';
import '../../../core/localdatabase/local_database_helper.dart';

class SummaryLocal {
  Future<SummaryResponse> getSummary() async {
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

    Map<String, dynamic> response = {
      "orderItemList": itemTotal,
      "totals": total.first["Total"],
      "payTypeTotalMap": payTypeTotalMap
    };

    return SummaryResponse.fromJson(response);
  }
}
