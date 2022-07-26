import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/core/localdatabase/local_database_helper.dart';

final localDatabaseHelperProvider =
    Provider<LocalDatabaseHelperTest>((ref) => LocalDatabaseHelperTest());
