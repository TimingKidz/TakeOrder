// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      orderItemList: (json['orderItemList'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OrderItem>[],
      totals: (json['totals'] as num?)?.toDouble() ?? 0,
      payTypeTotalMap:
          json['payTypeTotalMap'] as Map<String, dynamic>? ?? const {},
    );
