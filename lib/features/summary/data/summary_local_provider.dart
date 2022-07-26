import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/features/summary/data/mapper/summary_mapper.dart';
import 'package:invoice_manage/features/summary/data/summary_local.dart';
import 'package:invoice_manage/features/summary/data/summary_local_datasource.dart';

final summaryLocalProvider = Provider<SummaryLocal>((ref) {
  return SummaryLocal();
});

final summaryMapperProvider = Provider<SummaryMapper>((ref) {
  return SummaryMapper();
});

final summaryLocalDatasourceProvider = Provider<SummaryLocalDataSource>((ref) {
  return SummaryLocalDataSourceImpl(
      summaryLocal: ref.watch(summaryLocalProvider),
      summaryMapper: ref.watch(summaryMapperProvider));
});
