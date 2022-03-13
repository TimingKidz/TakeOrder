import 'package:invoice_manage/model/SummaryData.dart';
import 'package:invoice_manage/providers/order_provider.dart';
import 'package:invoice_manage/summary/domain/SummaryRepository.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final OrderDbProvider _orderDbProvider;

  const SummaryRepositoryImpl(this._orderDbProvider);

  @override
  Future<SummaryData> getSummaryData() async {
    return _orderDbProvider.getSummary();
  }

}