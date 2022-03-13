import 'package:flutter/cupertino.dart';
import 'package:invoice_manage/summary/domain/usecases/GetSummaryUseCase.dart';

import '../../model/OrderItem.dart';

class SummaryProvider with ChangeNotifier {
  final GetSummaryUseCase _getSummaryUseCase;

  SummaryProvider(this._getSummaryUseCase);

  List<OrderItem>? _orderItemList;
  late List<OrderItem> _all;
  double _totals = 0;
  TextEditingController _searchText = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusNode _textFieldFocusNode = FocusNode();

  List<OrderItem> get orderItemList => _orderItemList ?? List.empty();

  double get totals => _totals;

  TextEditingController get searchText => _searchText;

  ScrollController get scrollController => _scrollController;

  FocusNode get textFieldFocusNode => _textFieldFocusNode;

  bool get isInitialized => _orderItemList != null;

  Future<void> getSummary() async {
    var data = await _getSummaryUseCase.call();
    _orderItemList = data.orderItemList;
    _all = data.orderItemList;
    _totals = data.totals;
    notifyListeners();
  }

  Future<void> searchFilter(String s) async {
    if (s.isNotEmpty) {
      List<OrderItem> _filter = _all.where((item) {
        var title = item.itemName.toLowerCase();
        return title.contains(s);
      }).toList();
      _filter.sort(
          (a, b) => a.itemName.indexOf(s).compareTo(b.itemName.indexOf(s)));
      _orderItemList = _filter;
    } else {
      _orderItemList = _all;
    }
    notifyListeners();
  }
}
