import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/features/order/presenter/order_provider.dart';

import '../memo/presenter/pages/memoPage.dart';
import '../summary/presenter/summary_provider.dart';

final pageRoute = Provider((ref) {
  final summaryPage = ref.watch(summaryPageProvider);
  final orderPage = ref.watch(orderPageProvider);
  return [MemoPage(), summaryPage, orderPage];
});

final currentPageProvider =
    StateProvider<int>((ref) => 2, name: "Landing Page");
