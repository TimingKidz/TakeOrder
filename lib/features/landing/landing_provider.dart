import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/pages/poc_new_ui.dart';

import '../../pages/orderPage.dart';
import '../memo/presenter/pages/memoPage.dart';
import '../summary/presenter/summary_provider.dart';

final pageRoute = Provider((ref) {
  final summaryPage = ref.watch(summaryPageProvider);
  return [MemoPage(), summaryPage, OrderPage(), PocNewUI()];
});

final currentPageProvider =
    StateProvider<int>((ref) => 2, name: "Landing Page");
