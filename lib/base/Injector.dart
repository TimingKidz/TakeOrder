import 'package:get_it/get_it.dart';
import 'package:invoice_manage/providers/order_provider.dart';
import 'package:invoice_manage/summary/data/SummaryModule.dart';
import 'package:invoice_manage/summary/data/SummaryRepositoryImpl.dart';
import 'package:invoice_manage/summary/domain/SummaryRepository.dart';
import 'package:invoice_manage/summary/domain/usecases/GetSummaryUseCase.dart';
import 'package:invoice_manage/summary/presentation/SummaryProvider.dart';
import 'package:invoice_manage/widget/SummaryListWidget.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  summaryModule();
}