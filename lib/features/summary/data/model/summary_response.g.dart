// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryResponse _$SummaryResponseFromJson(Map<String, dynamic> json) =>
    SummaryResponse(
      orderItemList: (json['orderItemList'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: (json['totals'] as num).toDouble(),
      payTypeTotalMap: json['payTypeTotalMap'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SummaryResponseToJson(SummaryResponse instance) =>
    <String, dynamic>{
      'orderItemList': instance.orderItemList.map((e) => e.toJson()).toList(),
      'totals': instance.totals,
      'payTypeTotalMap': instance.payTypeTotalMap,
    };
