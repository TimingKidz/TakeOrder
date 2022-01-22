import 'dart:async';

import 'package:invoice_manage/model/order.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/providers/order_provider.dart';

class SummaryBloc {
  SummaryBloc() {
    getSummary();
  }

  List<OrderList> all = [];
  List<OrderList> focus = [];
  double totals = 0;

  final _summaryController = StreamController<List<OrderList>>.broadcast();
  final _summaryTotalController = StreamController<double>.broadcast();

  get allItems => _summaryController.stream;

  get total => _summaryTotalController.stream;

  getSummary() async {
    var data = await OrderDbProvider.db.getAllOrders();
    all = allOrdersList(data);
    totals = allTotal(data);
    _summaryController.sink.add(all);
    _summaryTotalController.sink.add(totals);
  }

  List<OrderList> allOrdersList(List<Order> data) {
    List<OrderList> finalData = [];

    data.forEach((Order element) {
      finalData.addAll(element.list);
    });

    return finalData;
  }

  double allTotal(List<Order> data) {
    double totals = 0;

    data.forEach((element) {
      totals = totals + element.total;
    });

    return totals;
  }

  Future<void> searchFilter(String s) async {
    if (s.isNotEmpty) {
      List<OrderList> filter = all.where((item) {
        var title = item.itemName.toLowerCase();
        return title.contains(s);
      }).toList();
      _summaryController.sink.add(filter);
    } else {
      _summaryController.sink.add(all);
    }
  }

  dispose() {
    _summaryController.close();
    _summaryTotalController.close();
  }
}
