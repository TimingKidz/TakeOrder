import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/orderBloc.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/utils/Formatters.dart';
import 'package:invoice_manage/widget/itemedit_dialog.dart';

class OrderListWidget extends StatefulWidget {
  final OrderBloc orderBloc;

  const OrderListWidget({Key? key, required this.orderBloc}) : super(key: key);

  @override
  _OrderListWidgetState createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  var listPrice = TextEditingController();
  var qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OrderList>>(
      stream: widget.orderBloc.orderList,
      builder: (BuildContext context, AsyncSnapshot<List<OrderList>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              OrderList data = snapshot.data![index];
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
                          style:
                              TextStyle(color: Colors.black45, fontSize: 12.0)),
                    ],
                  ),
                  trailing: Text(
                      NumberFormat.currency(symbol: "", decimalDigits: 2)
                          .format(data.listPrice * data.qty)),
                  onTap: () => editItemFromOrder(data),
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
      },
    );
  }

  Future<void> editItemFromOrder(OrderList data) async {
    listPrice.text = textFieldPriceFormatter(data.listPrice);
    qty.text = data.qty.toString();

    String t = await showDialog(
            context: context,
            builder: (BuildContext context) => ItemEditDialog(
                listPrice: listPrice, qty: qty, itemName: data.itemName)) ??
        "Cancel";

    if (t == "Delete")
      widget.orderBloc.delete(data);
    else if (t == "Update")
      widget.orderBloc
          .update(data, double.parse(listPrice.text), int.parse(qty.text));

    listPrice.clear();
    qty.clear();
  }
}
