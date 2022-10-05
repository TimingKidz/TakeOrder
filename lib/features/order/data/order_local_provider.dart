import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/features/order/data/mapper/order_mapper.dart';
import 'package:invoice_manage/features/order/data/order_local.dart';
import 'package:invoice_manage/features/order/data/order_local_datasource.dart';

final orderLocalProvider = Provider<OrderLocal>((ref) {
  return OrderLocal();
});

final orderMapperProvider = Provider<OrderMapper>((ref) {
  return OrderMapper();
});

final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {
  return OrderLocalDataSourceImpl(
      orderLocal: ref.watch(orderLocalProvider),
      orderMapper: ref.watch(orderMapperProvider));
});
