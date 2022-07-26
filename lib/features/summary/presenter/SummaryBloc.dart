import 'dart:async';

import 'package:invoice_manage/model/order_item.dart';
import 'package:invoice_manage/providers/order_provider.dart';

class SummaryBloc {
  SummaryBloc() {
    getSummary();
  }

  List<OrderItem> all = [];
  List<OrderItem> focus = [];
  double totals = 0;

  final _summaryController = StreamController<List<OrderItem>>.broadcast();
  final _summaryTotalController = StreamController<double>.broadcast();
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get allItems => _summaryController.stream;

  get total => _summaryTotalController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getSummary() async {
    var data = await OrderDbProvider.db.getSummary();
    all = data.orderItemList;
    totals = data.totals;
    _summaryController.sink.add(all);
    _summaryTotalController.sink.add(totals);
  }

  Future<void> searchFilter(String s) async {
    if (s.isNotEmpty) {
      List<OrderItem> filter = all.where((item) {
        var title = item.itemName.toLowerCase();
        return title.contains(s);
      }).toList();
      filter.sort(
          (a, b) => a.itemName.indexOf(s).compareTo(b.itemName.indexOf(s)));
      _summaryController.sink.add(filter);
    } else {
      _summaryController.sink.add(all);
    }
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  dispose() {
    _summaryController.close();
    _summaryTotalController.close();
    _isShowKeyboardController.close();
  }
}
