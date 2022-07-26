import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  final String itemName;
  @JsonKey(name: "SubTotal")
  final double subTotal;
  final int qty;

  OrderItem({this.itemName = "", this.subTotal = 0, this.qty = 0});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
