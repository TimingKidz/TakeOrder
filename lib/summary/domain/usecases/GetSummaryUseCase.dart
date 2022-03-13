import 'package:invoice_manage/base/UseCase.dart';
import 'package:invoice_manage/model/SummaryData.dart';
import 'package:invoice_manage/summary/domain/SummaryRepository.dart';

class GetSummaryUseCase implements UseCase<void, SummaryData> {
  final SummaryRepository _summaryRepository;

  GetSummaryUseCase(this._summaryRepository);

  @override
  Future<SummaryData> call({void params}) {
    return _summaryRepository.getSummaryData();
  }

}