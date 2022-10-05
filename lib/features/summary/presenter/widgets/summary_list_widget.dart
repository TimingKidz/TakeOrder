import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/features/order/domain/entities/order_item.dart';
import 'package:invoice_manage/features/summary/presenter/summary_provider.dart';

import '../../../../core/constants/spacing_constants.dart';

class SummaryListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<OrderItem> summaryItem = ref.watch(
        summaryDisplayProvider.select((summary) => summary.orderItemList));

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(spacingSmallX),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.black45),
        ),
        child: ListView.separated(
          itemCount: summaryItem.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            OrderItem data = summaryItem.elementAt(index);
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
        ),
      ),
    );
  }
}
