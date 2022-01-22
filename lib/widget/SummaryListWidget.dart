import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/SummaryBloc.dart';
import 'package:invoice_manage/model/orderList.dart';

class SummaryListWidget extends StatefulWidget {
  final SummaryBloc summaryBloc;

  const SummaryListWidget({Key? key, required this.summaryBloc})
      : super(key: key);

  @override
  _SummaryListWidgetState createState() => _SummaryListWidgetState();
}

class _SummaryListWidgetState extends State<SummaryListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderList>>(
      stream: widget.summaryBloc.allItems,
      builder: (BuildContext context, AsyncSnapshot<List<OrderList>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              OrderList data = snapshot.data!.elementAt(index);
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("${index + 1}",
                      style: TextStyle(color: Colors.black45, fontSize: 12)),
                ),
                ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${data.qty}"),
                    ],
                  ),
                  title: Text(data.itemName),
                  subtitle: Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 2)
                          .format(data.listPrice)),
                  trailing: Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 2)
                          .format(data.listPrice * data.qty)),
                ),
              ]);
            },
            separatorBuilder: (_, index) {
              return Divider(thickness: 1.5);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
