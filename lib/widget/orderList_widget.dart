import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/features/order/presenter/order_provider.dart';

import '../features/order/domain/entities/order_list.dart';

class OrderListWidget extends ConsumerWidget {
  OrderListWidget({
    Key? key,
  }) : super(key: key);

  final listPrice = TextEditingController();
  final qty = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(selectOrderProvider);

    if (order != null) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: order.list?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          OrderList data =
              order.list?.elementAt(index) ?? OrderList(orderID: 0, itemID: 0);
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.itemName),
                  Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 2)
                          .format(data.listPrice),
                      style: TextStyle(color: Colors.black45, fontSize: 12.0)),
                ],
              ),
              trailing: Text(NumberFormat.currency(symbol: "", decimalDigits: 2)
                  .format(data.listPrice * data.qty)),
              // onTap: () => editItemFromOrder(data),
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
  }

// Future<void> editItemFromOrder(OrderList data) async {
//   listPrice.text = data.listPrice.priceStringFormatter();
//   qty.text = data.qty.toString();
//
//   String t = await showDialog(
//           context: context,
//           builder: (BuildContext context) => ItemEditDialog(
//               listPrice: listPrice, qty: qty, itemName: data.itemName)) ??
//       "Cancel";
//
//   if (t == "Delete")
//     widget.orderBloc.delete(data);
//   else if (t == "Update")
//     widget.orderBloc
//         .update(data, double.parse(listPrice.text), int.parse(qty.text));
//
//   listPrice.clear();
//   qty.clear();
// }
}
