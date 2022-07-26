import 'package:invoice_manage/features/summary/data/model/summary_response.dart';
import 'package:invoice_manage/features/summary/domain/entities/summary.dart';

class SummaryMapper {
  Summary mapper(SummaryResponse response) {
    return Summary.fromJson(response.toJson());
  }
}
