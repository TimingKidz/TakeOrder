import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/SummaryBloc.dart';
import 'package:invoice_manage/model/OrderItem.dart';
import 'package:provider/provider.dart';

import '../base/Injector.dart';
import '../summary/presentation/SummaryProvider.dart';

class SummaryListWidget extends StatelessWidget {
  final SummaryProvider provider;
  final ScrollController controller;

  SummaryListWidget(
      {Key? key, required this.provider, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SummaryProvider>.value(
        value: provider,
        child: Consumer<SummaryProvider>(builder: (_, provider, __) {
          if (provider.isInitialized) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              controller: controller,
              itemCount: provider.orderItemList.length,
              itemBuilder: (BuildContext context, int index) {
                OrderItem data = provider.orderItemList.elementAt(index);
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
                    trailing: Text(
                        NumberFormat.currency(symbol: "", decimalDigits: 2)
                            .format(data.subTotal)),
                  ),
                ]);
              },
              separatorBuilder: (_, index) {
                return Divider(thickness: 1.5, height: 1.5);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }
}
