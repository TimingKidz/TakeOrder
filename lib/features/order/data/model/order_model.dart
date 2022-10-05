import 'package:invoice_manage/features/order/domain/entities/order.dart';
import 'package:invoice_manage/features/order/domain/entities/order_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel extends Order {
  OrderModel({required int orderID, required DateTime date})
      : super(orderID: orderID, date: date);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
