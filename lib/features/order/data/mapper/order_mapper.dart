import 'package:invoice_manage/features/order/data/model/order_model.dart';

import '../../domain/entities/order.dart';

class OrderMapper {
  List<Order> mapper(List<OrderModel> response) {
    return response
        .map((orderModel) => Order.fromJson(orderModel.toJson()))
        .toList();
  }
}
