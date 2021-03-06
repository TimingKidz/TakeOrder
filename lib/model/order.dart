import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/providers/db_provider.dart';

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
      orderID: json[DbProvider.orderID],
      payType: json[DbProvider.payType],
      soldTo: json[DbProvider.soldTo] ?? null,
      total: json[DbProvider.total],
      date: DateTime.parse(json[DbProvider.date]),
      list: []
    );
  }

  Map<String, dynamic> toMap() => {
    DbProvider.orderID: orderID,
    DbProvider.payType: payType,
    DbProvider.soldTo: soldTo,
    DbProvider.total: total,
    DbProvider.date: date
  };
}