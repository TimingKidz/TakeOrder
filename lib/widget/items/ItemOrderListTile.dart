import 'package:flutter/material.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/utils/Formatters.dart';
import 'package:invoice_manage/config/Dimens.dart';

class ItemOrderListTile extends StatelessWidget {
  final int index;
  final OrderList data;
  final Function(OrderList)? onItemTap;

  const ItemOrderListTile({Key? key,required this.index,required this.data, this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(Dimens.spacing_xx_small),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.itemName),
            Text(
              twoDecimalNumberFormat(data.listPrice),
                style:
                TextStyle(color: Colors.black45, fontSize: 12.0)),
          ],
        ),
        trailing: Text(
            twoDecimalNumberFormat(data.listPrice * data.qty)),
        onTap: onItemTap!(data),
      ),
    ]);
  }
}
