// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      itemName: json['itemName'] as String? ?? "",
      subTotal: (json['SubTotal'] as num?)?.toDouble() ?? 0,
      qty: json['qty'] as int? ?? 0,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'itemName': instance.itemName,
      'SubTotal': instance.subTotal,
      'qty': instance.qty,
    };
