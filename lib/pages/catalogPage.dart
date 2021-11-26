import 'package:intl/intl.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/catalogBloc.dart';
import 'package:invoice_manage/blocs/orderBloc.dart';
import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/widget/addItem_dialog.dart';
import 'package:invoice_manage/widget/addtoOrder_dialog.dart';
import 'package:invoice_manage/widget/catalogedit_dialog.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';
import 'package:invoice_manage/widget/searchbar.dart';

class CatalogPage extends StatefulWidget {
  final OrderBloc orderBloc;

  const CatalogPage({Key? key, required this.orderBloc}) : super(key: key);

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final catalogBloc = CatalogBloc();
  var itemName = TextEditingController();
  var itemPrice = TextEditingController();
  var listPrice = TextEditingController();
  var qty = TextEditingController();
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Item(s) from Catalog"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItem(),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SearchBar(bloc: catalogBloc),
          ),
          SizedBox(height: 8.0),
          StreamBuilder<List<Item>>(
            stream: catalogBloc.catalog,
            builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 92),
                      itemCount: snapshot.data?.length ?? 0,
                      separatorBuilder: (_, index) {
                        return Divider(thickness: 1.5);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Slidable(
                          key: Key(snapshot.data![index].itemName),
                          controller: slidableController,
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            title: Text(snapshot.data![index].itemName),
                            trailing: Text(NumberFormat.currency(symbol: "", decimalDigits: 2).format(snapshot.data![index].itemPrice)),
                            onTap: () => addItemToOrder(snapshot.data![index]),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.black45,
                              icon: Icons.edit,
                              onTap: () => editItem(snapshot.data![index]),
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => deleteItem(snapshot.data![index]),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }else{
                  return Expanded(child: Center(child: Text("No item in catalog, please add your first item.")));
                }
              }else{
                return Expanded(child: Center(child: CircularProgressIndicator()));
              }
            }
          ),
        ],
      ),
    );
  }

  Future<void> addItem() async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => AddItemDialog(itemName: itemName, listPrice: itemPrice)
    ) ?? "Cancel";
    if(t == "Add") {
      double itemP = itemPrice.text.isNotEmpty ? double.parse(itemPrice.text) : 0;
      Item item = Item(itemName: itemName.text, itemPrice: itemP);
      catalogBloc.add(item);
    }
    itemName.clear();
    itemPrice.clear();
  }

  Future<void> editItem(Item item) async {
    itemName.text = item.itemName;
    itemPrice.text = item.itemPrice.toString().split(".").first;
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => CatalogEditDialog(itemName: itemName, itemPrice: itemPrice)
    ) ?? "Cancel";
    if(t == "Update") {
      double itemP = itemPrice.text.isNotEmpty ? double.parse(itemPrice.text) : 0;
      Item newItem = Item(itemName: itemName.text, itemPrice: itemP);
      catalogBloc.update(item, newItem);
    }
    itemName.clear();
    itemPrice.clear();
  }

  Future<void> deleteItem(Item item) async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => YesNoDialog(title: 'Delete Item ${item.itemName}')
    ) ?? "Cancel";
    if(t == "Yes") {
      catalogBloc.delete(item);
    }
  }

  Future<void> addItemToOrder(Item i) async {
    listPrice.text = i.itemPrice.toString().split(".").first;
    qty.text = "1";
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => AddToOrderDialog(itemName: i.itemName, listPrice: listPrice, qty: qty)
    ) ?? "Cancel";
    int o = widget.orderBloc.all.elementAt(widget.orderBloc.pageNum-1).orderID;
    if(t == "Add") {
      OrderList item = OrderList(orderID: o, itemID: i.itemID ?? -1, itemName: i.itemName, listPrice: double.parse(listPrice.text), qty: int.parse(qty.text));
      widget.orderBloc.add(item);
    }
    listPrice.clear();
    qty.clear();
  }
}
