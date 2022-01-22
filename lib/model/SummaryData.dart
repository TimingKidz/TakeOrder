import 'package:invoice_manage/model/OrderItem.dart';

class SummaryData {
  late List<OrderItem> orderItemList;
  late double totals;
  late Map<String, dynamic> payTypeTotalMap;

  SummaryData(
      {required this.orderItemList,
      required this.totals,
      required this.payTypeTotalMap});
}
