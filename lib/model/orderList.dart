import 'package:invoice_manage/core/local_database_helper.dart';

import '../core/constants/database_constants.dart';

class OrderList {
  late int? orderListID;
  late int orderID;
  late int itemID;
  late String itemName;
  late double listPrice;
  late int qty;

  OrderList(
      {this.orderListID,
      required this.orderID,
      required this.itemID,
      required this.itemName,
      required this.listPrice,
      required this.qty});

  factory OrderList.fromMap(Map<String, dynamic> json) {
    return OrderList(
        orderListID: json[DatabaseConstants.orderListId],
        orderID: json[DatabaseConstants.orderID],
        itemID: json[DatabaseConstants.itemID],
        itemName: json[DatabaseConstants.itemName],
        listPrice: json[DatabaseConstants.listPrice],
        qty: json[DatabaseConstants.qty]);
  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.orderID: orderID,
        DatabaseConstants.itemID: itemID,
        DatabaseConstants.listPrice: listPrice,
        DatabaseConstants.qty: qty
      };
}
