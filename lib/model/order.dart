import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/providers/db_provider.dart';

class Order {
  late int orderID;
  late String payType;
  int? soldTo;
  String? companyName;
  late double total;
  DateTime date;
  late List<OrderList> list;
  String? cusName;
  String? address;

  Order({
    required this.orderID,
    required this.payType,
    this.soldTo,
    this.companyName,
    required this.total,
    required this.date,
    required this.list,
    this.address,
    this.cusName
  });

  factory Order.fromMap(Map<String, dynamic> json) {
    return Order(
      orderID: json[DbProvider.orderID],
      payType: json[DbProvider.payType],
      soldTo: json[DbProvider.soldTo] ?? null,
      companyName: json[DbProvider.companyName] ?? null,
      total: json[DbProvider.total],
      date: DateTime.parse(json[DbProvider.date]),
      cusName: json[DbProvider.cusName] ?? null,
      address: json[DbProvider.address] ?? null,
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