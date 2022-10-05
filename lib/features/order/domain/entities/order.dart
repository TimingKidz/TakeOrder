import 'package:invoice_manage/features/order/domain/order_pay_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_list.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final int orderID;
  final OrderPayType payType;
  final String? soldTo;
  final double total;
  final DateTime date;
  late List<OrderList>? list;

  Order({
    required this.orderID,
    this.payType = OrderPayType.CASH_SALE,
    this.soldTo,
    this.total = 0,
    required this.date,
    this.list,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
