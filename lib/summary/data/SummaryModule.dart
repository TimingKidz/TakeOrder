import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:invoice_manage/base/Injector.dart';
import 'package:invoice_manage/providers/order_provider.dart';
import 'package:invoice_manage/summary/presentation/SummaryPage.dart';

import '../domain/SummaryRepository.dart';
import '../domain/usecases/GetSummaryUseCase.dart';
import '../presentation/SummaryProvider.dart';
import 'SummaryRepositoryImpl.dart';

void summaryModule() {
  // Database Provide
  getIt.registerLazySingleton(() => OrderDbProvider.db);

  // Summary Repository
  getIt.registerLazySingleton<SummaryRepository>(
          () => SummaryRepositoryImpl(getIt()));

  // Summary UseCase
  getIt.registerLazySingleton(() => GetSummaryUseCase(getIt()));

  // Summary Provider
  getIt.registerFactory(() => SummaryProvider(getIt()));

  // Summary Page
  getIt.registerFactory(() => SummaryPage(summaryProvider: getIt()));
}
