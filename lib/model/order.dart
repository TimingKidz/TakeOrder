import 'package:invoice_manage/model/orderList.dart';

import '../core/constants/database_constants.dart';

class Order {
  late int orderID;
  late String payType;
  String? soldTo;
  late double total;
  DateTime date;
  late List<OrderList> list;

  Order({
    required this.orderID,
    required this.payType,
    this.soldTo,
    required this.total,
    required this.date,
    required this.list,
  });

  factory Order.fromMap(Map<String, dynamic> json) {
    return Order(
        orderID: json[DatabaseConstants.orderID],
        payType: json[DatabaseConstants.payType],
        soldTo: json[DatabaseConstants.soldTo] ?? null,
        total: json[DatabaseConstants.total],
        date: DateTime.parse(json[DatabaseConstants.date]),
        list: []);
  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.orderID: orderID,
        DatabaseConstants.payType: payType,
        DatabaseConstants.soldTo: soldTo,
        DatabaseConstants.total: total,
        DatabaseConstants.date: date
      };
}
