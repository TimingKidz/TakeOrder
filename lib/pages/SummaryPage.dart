import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/SummaryBloc.dart';
import 'package:invoice_manage/widget/SummaryListWidget.dart';
import 'package:invoice_manage/widget/searchbar.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final summaryBloc = SummaryBloc();

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
              child: SearchBar(bloc: summaryBloc),
            ),
          ),
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.all(8.0),
          //     decoration: BoxDecoration(
          //       border: Border.all(width: 1.5, color: Colors.black45),
          //     ),
          //     child: SummaryListWidget(summaryBloc: summaryBloc),
          //   ),
          // ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamBuilder<double>(
                stream: summaryBloc.total,
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total: ",
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                            NumberFormat.currency(symbol: "", decimalDigits: 2)
                                .format(snapshot.data),
                            style: Theme.of(context)
                                .textTheme
                                .headline6) // Total Value
                      ],
                    );
                  }
                  return Container();
                }),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
