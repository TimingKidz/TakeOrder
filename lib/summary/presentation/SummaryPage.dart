import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/base/Injector.dart';
import 'package:invoice_manage/blocs/SummaryBloc.dart';
import 'package:invoice_manage/summary/presentation/SummaryPageSearchBar.dart';
import 'package:invoice_manage/summary/presentation/SummaryProvider.dart';
import 'package:invoice_manage/widget/SummaryListWidget.dart';
import 'package:invoice_manage/widget/searchbar.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final SummaryProvider summaryProvider;

  const SummaryPage({Key? key, required this.summaryProvider})
      : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {

  @override
  void initState() {
    super.initState();
    widget.summaryProvider.getSummary();

    // init listener
    widget.summaryProvider.scrollController.addListener(() {
      widget.summaryProvider.textFieldFocusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: SummaryPageSearchBar(
                  provider: widget.summaryProvider,
                  searchText: widget.summaryProvider.searchText,
                  textFieldFocusNode:
                      widget.summaryProvider.textFieldFocusNode),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black45),
              ),
              child: SummaryListWidget(
                  provider: widget.summaryProvider,
                  controller: widget.summaryProvider.scrollController),
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ChangeNotifierProvider<SummaryProvider>.value(
                value: widget.summaryProvider,
                child: Consumer<SummaryProvider>(
                  builder: (context, data, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total: ",
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                            NumberFormat.currency(symbol: "", decimalDigits: 2)
                                .format(data.totals),
                            style: Theme.of(context)
                                .textTheme
                                .headline6) // Total Value
                      ],
                    );
                  },
                ),
              )),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
