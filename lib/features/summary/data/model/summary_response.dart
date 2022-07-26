import 'package:invoice_manage/features/summary/domain/entities/summary.dart';
import 'package:invoice_manage/model/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SummaryResponse extends Summary {
  SummaryResponse(
      {required List<OrderItem> orderItemList,
      required double totals,
      required Map<String, dynamic> payTypeTotalMap})
      : super(
            orderItemList: orderItemList,
            totals: totals,
            payTypeTotalMap: payTypeTotalMap);

  factory SummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$SummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryResponseToJson(this);
}
