import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/orderBloc.dart';
import 'package:invoice_manage/model/orderList.dart';
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
        if(snapshot.hasData){
          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              OrderList data = snapshot.data![index];
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${data.qty}"),
                  ],
                ),
                title: Text(data.itemName),
                subtitle: Text(NumberFormat.currency(symbol: "", decimalDigits: 2).format(data.listPrice)),
                trailing: Text(NumberFormat.currency(symbol: "", decimalDigits: 2).format(data.listPrice * data.qty)),
                onTap: () => editItemFromOrder(data),
              );
            },
            separatorBuilder: (_, index) {
              return Divider(thickness: 1.5);
            },
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> editItemFromOrder(OrderList data) async {
    listPrice.text = data.listPrice.toString().split(".").first;
    qty.text = data.qty.toString();

    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => ItemEditDialog(listPrice: listPrice, qty: qty, itemName: data.itemName)
    ) ?? "Cancel";

    if(t == "Delete") widget.orderBloc.delete(data);
    else if(t == "Update") widget.orderBloc.update(data, double.parse(listPrice.text), int.parse(qty.text));

    listPrice.clear();
    qty.clear();
  }
}
