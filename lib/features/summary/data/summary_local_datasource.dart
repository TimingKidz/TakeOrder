import 'package:invoice_manage/features/summary/data/summary_local.dart';

import '../domain/entities/summary.dart';
import 'mapper/summary_mapper.dart';

abstract class SummaryLocalDataSource {
  Future<Summary> getSummaryData();
}

class SummaryLocalDataSourceImpl implements SummaryLocalDataSource {
  final SummaryLocal summaryLocal;
  final SummaryMapper summaryMapper;

  SummaryLocalDataSourceImpl(
      {required this.summaryLocal, required this.summaryMapper});

  @override
  Future<Summary> getSummaryData() async {
    final getSummary = await summaryLocal.getSummary();
    return summaryMapper.mapper(getSummary);
  }
}
