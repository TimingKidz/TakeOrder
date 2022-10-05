import 'package:invoice_manage/features/order/data/order_local.dart';
import 'package:invoice_manage/features/order/domain/entities/order.dart';

import '../domain/entities/order_list.dart';
import 'mapper/order_mapper.dart';

abstract class OrderLocalDataSource {
  Future<List<Order>> getAllOrders();

  Future<void> addOrderHead();

  Future<void> clearOrder(int id);

  Future<void> updateTotal(int id, double total);

  Future<void> deleteOrderHead(int id);

  Future<void> deleteAllOrder();

  Future<double> newItem(OrderList newItem);

  Future<double> updateItem(OrderList upItem, double listPrice, int qty);

  Future<double> deleteItem(OrderList delItem);

  Future<void> updatePayType(int headID, String type);

  Future<void> updateSoldTo(int headID, dynamic cusID);

  Future<void> updateTime(int orderID);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final OrderLocal orderLocal;
  final OrderMapper orderMapper;

  OrderLocalDataSourceImpl(
      {required this.orderLocal, required this.orderMapper});

  @override
  Future<List<Order>> getAllOrders() async {
    final getOrders = await orderLocal.getAllOrders();
    return orderMapper.mapper(getOrders);
  }

  @override
  Future<void> addOrderHead() async {
    await orderLocal.addOrderHead();
  }

  @override
  Future<void> clearOrder(int id) async {
    await orderLocal.clearOrder(id);
  }

  @override
  Future<void> updateTotal(int id, double total) async {
    await orderLocal.updateTotal(id, total);
  }

  @override
  Future<void> deleteOrderHead(int id) async {
    await orderLocal.deleteOrderHead(id);
  }

  @override
  Future<void> deleteAllOrder() async {
    await orderLocal.deleteAllOrder();
  }

  @override
  Future<double> deleteItem(OrderList delItem) async {
    return await orderLocal.deleteItem(delItem);
  }

  @override
  Future<double> newItem(OrderList newItem) async {
    return await orderLocal.newItem(newItem);
  }

  @override
  Future<double> updateItem(OrderList upItem, double listPrice, int qty) async {
    return await orderLocal.updateItem(upItem, listPrice, qty);
  }

  @override
  Future<void> updatePayType(int headID, String type) async {
    await orderLocal.updatePayType(headID, type);
  }

  @override
  Future<void> updateSoldTo(int headID, cusID) async {
    await orderLocal.updateSoldTo(headID, cusID);
  }

  @override
  Future<void> updateTime(int orderID) async {
    await orderLocal.updateTime(orderID);
  }
}
