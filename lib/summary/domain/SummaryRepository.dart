import 'package:invoice_manage/model/SummaryData.dart';

abstract class SummaryRepository {
  Future<SummaryData> getSummaryData();
}