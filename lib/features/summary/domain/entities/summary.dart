import 'package:invoice_manage/features/order/domain/entities/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable(createToJson: false)
class Summary {
  final List<OrderItem> orderItemList;
  final double totals;
  final Map<String, dynamic> payTypeTotalMap;

  Summary(
      {this.orderItemList = const <OrderItem>[],
      this.totals = 0,
      this.payTypeTotalMap = const {}});

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
}
