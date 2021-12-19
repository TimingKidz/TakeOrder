import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/orderBloc.dart';
import 'package:invoice_manage/model/order.dart';
import 'package:invoice_manage/pages/catalogPage.dart';
import 'package:invoice_manage/pages/selectCustomerPage.dart';
import 'package:invoice_manage/widget/InfomationDialog.dart';
import 'package:invoice_manage/widget/deleteOrder_dialog.dart';
import 'package:invoice_manage/widget/exports_dialog.dart';
import 'package:invoice_manage/widget/orderList_widget.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final orderBloc = OrderBloc();
  bool isSwipeRight = false;
  bool isSwipeLeft = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Order>(
          stream: orderBloc.order,
          builder: (BuildContext context, AsyncSnapshot<Order> snapshot) {
            return GestureDetector(
              child: Text(snapshot.data?.soldTo ?? "Take An Order!"),
                onLongPress: () => databaseManagement(),
              );
          }
        ),
        actions: [
          StreamBuilder<int>(
            stream: orderBloc.orderNum,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if(snapshot.data != null){
                int snap = snapshot.data ?? -1;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: Text("$snap/${orderBloc.all.length}", style: TextStyle(fontSize: 18))),
                );
              }else{
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: Text("-/-", style: TextStyle(fontSize: 18))),
                );
              }
            }
          )
        ],
      ),
      body: Listener(
        onPointerMove: (moveEvent){
          int offset = 10;
          if(moveEvent.delta.dx > offset) {
            isSwipeRight = true;
          }else if(moveEvent.delta.dx < -offset) {
            isSwipeLeft = true;
          }
        },
        onPointerUp: (event){
          if(isSwipeRight) {
            isSwipeRight = false;
            if(orderBloc.all.length > 1) headChange(-1);
          }else if(isSwipeLeft) {
            isSwipeLeft = false;
            if(orderBloc.all.length > 1) headChange(1);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.black45),
                ),
                child: OrderListWidget(orderBloc: orderBloc),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder<Order>(
                stream: orderBloc.order,
                builder: (BuildContext context, AsyncSnapshot<Order> snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/3,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: snapshot.data?.payType ?? "Cash Sale",
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              // style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                // color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                // dropdownValue = newValue!;
                                orderBloc.payTypeChange(newValue!);
                              },
                              items: <String>['Cash Sale', 'Invoice']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Text("Total: ", style: Theme.of(context).textTheme.headline6)
                        ],
                      ),
                      Text(NumberFormat.currency(symbol: "", decimalDigits: 2).format(snapshot.hasData ? snapshot.data?.total : 0), style: Theme.of(context).textTheme.headline6) // Total Value
                    ],
                  );
                }
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    orderBloc.addOrderHead().then((value) {
                      if(value) ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You have some empty page.'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))
                          ),
                          duration: Duration(milliseconds: 1200),
                        )
                      );
                    });
                  },
                  child: Text("New", style: TextStyle(color: Colors.green)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5, color: Colors.green)),
                ),
                MaterialButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CatalogPage(orderBloc: orderBloc)),
                  ),
                  child: Text("Add Item"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5)),
                ),
                MaterialButton(
                  onPressed: () async {
                    // TODO: Request contact permission from user.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectCustomerPage()),
                    ).then((value) {
                      if(value == "CLEAR") orderBloc.payToChange(null);
                      else if(value != null) orderBloc.payToChange(value);
                    });
                  },
                  child: Text("Sold to"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5)),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            StreamBuilder<int>(
              stream: orderBloc.orderNum,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: orderBloc.all.length <= 1 ? null : () => headChange(-1),
                      shape: CircleBorder(
                        side: BorderSide(
                          width: 1.5,
                          color: orderBloc.all.length <= 1 ? Colors.black38 : Colors.black
                        )
                      ),
                      child: Icon(Icons.navigate_before),
                    ),
                    Row(
                      children: [
                        Tooltip(
                          child: InkWell(
                            onTap: (snapshot.data != null ? orderBloc.all.elementAt(snapshot.data! - 1).list.isEmpty : true) ? null : () => clearOrder(),
                            child: Container(
                              child: Icon(Icons.clear, color: (snapshot.data != null ? orderBloc.all.elementAt(snapshot.data! - 1).list.isEmpty : true) ? Colors.black38 : Colors.deepOrange),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(width: 1.5, color: (snapshot.data != null ? orderBloc.all.elementAt(snapshot.data! - 1).list.isEmpty : true) ? Colors.black38 : Colors.deepOrange)
                              ),
                              padding: EdgeInsets.all(4.5),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          message: "Clear all items in this order",
                        ),
                        SizedBox(width: 24.0),
                        Tooltip(
                          child: InkWell(
                            onTap: orderBloc.all.length <= 1 ? null : () => deleteOrder(),
                            child: Container(
                              child: Icon(Icons.delete, color: orderBloc.all.length <= 1 ? Colors.black38 : Colors.red),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(width: 1.5, color: orderBloc.all.length <= 1 ? Colors.black38 : Colors.red)
                              ),
                              padding: EdgeInsets.all(4.5),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          message: "Delete this order",
                        ),
                        SizedBox(width: 24.0),
                        Tooltip(
                          child: InkWell(
                            onTap: orderBloc.all.length == 1 && orderBloc.all.first.list.isEmpty ? null : () => exportsOrder(),
                            child: Container(
                              child: Icon(Icons.note, color: orderBloc.all.length == 1 && orderBloc.all.first.list.isEmpty ? Colors.black38 : Colors.blue),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(width: 1.5, color: orderBloc.all.length == 1 && orderBloc.all.first.list.isEmpty ? Colors.black38 : Colors.blue)
                              ),
                              padding: EdgeInsets.all(4.5),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          message: "Export to memo",
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: orderBloc.all.length <= 1 ? null : () => headChange(1),
                      shape: CircleBorder(
                          side: BorderSide(
                              width: 1.5,
                              color: orderBloc.all.length <= 1 ? Colors.black38 : Colors.black
                          )
                      ),
                      child: Icon(Icons.navigate_next),
                    ),
                  ],
                );
              }
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  void headChange(int func) {
    if(func == -1 && !((orderBloc.pageNum - 1) <= 0)){
      orderBloc.decrementPage();
    }else if(func == 1 && !(orderBloc.pageNum >= orderBloc.len)){
      orderBloc.incrementPage();
    }
  }

  Future<void> clearOrder() async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => YesNoDialog(title: "Clear all item in this order")
    ) ?? "Cancel";
    if(t == "Yes") {
      orderBloc.clearOrder();
    }
  }

  Future<void> deleteOrder() async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => DeleteOrderDialog()
    ) ?? "Cancel";
    if(t == "Delete") orderBloc.deleteOrderHead();
    else if(t == "DeleteAll") orderBloc.deleteAllOrder();
  }

  Future<void> exportsOrder() async {
    dynamic t = await showDialog(
            context: context,
            builder: (BuildContext context) => ExportsDialog()) ??
        "Cancel";
    if (t is List<bool>) {
      orderBloc.exports(t);
    }
  }

  Future<void> databaseManagement() async {
    double w = MediaQuery.of(context).size.width / 3;
    String databasePath =
        await getDatabasesPath(); //returns a directory which stores permanent files
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: w,
                  height: w,
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_circle_up, size: 40.0),
                        SizedBox(height: 8.0),
                        Text("Export")
                      ],
                    ),
                    onTap: () async {
                      Share.shareFiles(
                        ['$databasePath/database.db'],
                        subject: 'Database',
                        // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: w,
                  height: w,
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_circle_down, size: 40.0),
                        SizedBox(height: 8.0),
                        Text("Import")
                      ],
                    ),
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['db'],
                      );

                      if(result != null) {
                        File file = File(result.files.single.path ?? "");
                        file.copy('$databasePath/database.db');
                        Navigator.of(context).pop();
                        await importInformationDialog();
                        SystemNavigator.pop();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> importInformationDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) =>
            InformationDialog(content: "Please re-open application."));
  }
}
