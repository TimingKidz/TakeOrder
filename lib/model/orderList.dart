import 'package:invoice_manage/providers/db_provider.dart';

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
        orderListID: json[DbProvider.orderListId],
        orderID: json[DbProvider.orderID],
        itemID: json[DbProvider.itemID],
        itemName: json[DbProvider.itemName],
        listPrice: json[DbProvider.listPrice],
        qty: json[DbProvider.qty]);
  }

  Map<String, dynamic> toMap() => {
    DbProvider.orderID: orderID,
    DbProvider.itemID: itemID,
    DbProvider.listPrice: listPrice,
    DbProvider.qty: qty
  };
}