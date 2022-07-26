import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/features/summary/data/summary_local_provider.dart';
import 'package:invoice_manage/features/summary/domain/entities/summary.dart';
import 'package:invoice_manage/features/summary/presenter/pages/summary_page.dart';

import '../../../model/order_item.dart';

final summaryPageProvider = Provider<SummaryPage>((ref) => SummaryPage());

final allSummaryProvider =
    StateProvider<Summary>((ref) => Summary(), name: "All Summary");

final summaryDisplayProvider =
    StateProvider<Summary>((ref) => Summary(), name: "Summary on UI");

final getSummaryProvider = FutureProvider<void>((ref) async {
  final summary = ref.watch(allSummaryProvider.notifier);
  final summaryState = ref.watch(summaryDisplayProvider.notifier);

  Summary result =
      await ref.watch(summaryLocalDatasourceProvider).getSummaryData();

  summary.state = result;
  summaryState.state = result;
}, name: "Get Summary");

final searchFilterProvider =
    Provider.autoDispose.family<Summary, String>((ref, keyword) {
  final allSummary = ref.watch(allSummaryProvider);

  if (keyword.isNotEmpty) {
    List<OrderItem> filter = allSummary.orderItemList
        .where((item) => item.itemName.toLowerCase().contains(keyword))
        .toList();
    filter.sort((a, b) =>
        a.itemName.indexOf(keyword).compareTo(b.itemName.indexOf(keyword)));
    return Summary(
        orderItemList: filter,
        totals: allSummary.totals,
        payTypeTotalMap: allSummary.payTypeTotalMap);
  } else {
    return ref.read(allSummaryProvider);
  }
});
