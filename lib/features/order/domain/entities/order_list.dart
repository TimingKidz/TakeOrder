import 'package:json_annotation/json_annotation.dart';

part 'order_list.g.dart';

@JsonSerializable()
class OrderList {
  final int? orderListID;
  final int orderID;
  final int itemID;
  final String itemName;
  final double listPrice;
  final int qty;

  OrderList(
      {this.orderListID,
      required this.orderID,
      required this.itemID,
      this.itemName = "",
      this.listPrice = 0,
      this.qty = 0});

  factory OrderList.fromJson(Map<String, dynamic> json) =>
      _$OrderListFromJson(json);

  Map<String, dynamic> toJson() => _$OrderListToJson(this);
}
