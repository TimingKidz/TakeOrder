import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/core/constants/spacing_constants.dart';
import 'package:invoice_manage/core/localize/localize_en.dart';
import 'package:invoice_manage/features/summary/domain/entities/summary.dart';

import '../../../../widget/searchbar_test.dart';
import '../summary_provider.dart';
import '../widgets/summary_list_widget.dart';

class SummaryPage extends ConsumerStatefulWidget {
  const SummaryPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SummaryPageState();
}

class _SummaryPageState extends ConsumerState<SummaryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(getSummaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    Summary summary = ref.watch(summaryDisplayProvider);

    Widget bottomContent = Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacingNormal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(summaryTotal, style: Theme.of(context).textTheme.headline6),
            Text(
                NumberFormat.currency(symbol: "", decimalDigits: 2)
                    .format(summary.totals),
                style: Theme.of(context).textTheme.headline6) // Total Value
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Column(
        children: [
          SearchBar(),
          SummaryListWidget(),
          SizedBox(height: spacingSmallX),
          bottomContent,
          SizedBox(height: spacingNormal),
        ],
      ),
    );
  }
}
