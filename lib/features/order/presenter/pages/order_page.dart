import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/features/order/domain/order_page_action.dart';
import 'package:invoice_manage/features/order/domain/order_pay_type.dart';
import 'package:invoice_manage/features/order/presenter/order_provider.dart';
import 'package:invoice_manage/pages/selectCustomerPage.dart';
import 'package:invoice_manage/widget/deleteOrder_dialog.dart';
import 'package:invoice_manage/widget/dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../widget/orderList_widget.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  bool isSwipeRight = false;
  bool isSwipeLeft = false;

  @override
  void initState() {
    ref.read(orderPageViewModelProvider).getAllOrdersProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allOrder = ref.watch(allOrdersProvider);
    final order = ref.watch(selectOrderProvider);
    final index = ref.watch(orderPageNumProvider);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(order?.soldTo ?? "Take An Order!"),
          // onLongPress: () => databaseManagement(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text("$index/${allOrder.length}",
                    style: TextStyle(fontSize: 18))),
          )
        ],
      ),
      body: Listener(
        onPointerMove: (moveEvent) {
          int offset = 10;
          int offsetY = 2;
          if (moveEvent.delta.dx > offset &&
              moveEvent.delta.dy < offsetY &&
              moveEvent.delta.dy > -offsetY) {
            isSwipeRight = true;
          } else if (moveEvent.delta.dx < -offset &&
              moveEvent.delta.dy < offsetY &&
              moveEvent.delta.dy > -offsetY) {
            isSwipeLeft = true;
          }
        },
        onPointerUp: (event) {
          // if (isSwipeRight) {
          //   isSwipeRight = false;
          //   if (orderBloc.all.length > 1) headChange(-1);
          // } else if (isSwipeLeft) {
          //   isSwipeLeft = false;
          //   if (orderBloc.all.length > 1) headChange(1);
          // }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.black45),
                ),
                child: OrderListWidget(),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: DropdownButton<OrderPayType>(
                            isExpanded: true,
                            value: order?.payType ?? OrderPayType.CASH_SALE,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (OrderPayType? newValue) {
                              ref
                                  .read(orderPageViewModelProvider)
                                  .payTypeChange(newValue?.displayName ?? "");
                            },
                            items: <OrderPayType>[
                              OrderPayType.CASH_SALE,
                              OrderPayType.INVOICE
                            ].map<DropdownMenuItem<OrderPayType>>(
                                (OrderPayType value) {
                              return DropdownMenuItem<OrderPayType>(
                                value: value,
                                child: Text(value.displayName),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text("Total: ",
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    ),
                    Text(
                        NumberFormat.currency(symbol: "", decimalDigits: 2)
                            .format(order?.total ?? 0),
                        style: Theme.of(context)
                            .textTheme
                            .headline6) // Total Value
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    ref
                        .read(orderPageViewModelProvider)
                        .addOrderHead()
                        .then((value) {
                      if (value)
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You have some empty page.'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0))),
                          duration: Duration(milliseconds: 1200),
                        ));
                    });
                  },
                  child: Text("New", style: TextStyle(color: Colors.green)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5, color: Colors.green)),
                ),
                MaterialButton(
                  // onPressed: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           CatalogPage(orderBloc: orderBloc)),
                  // ),
                  child: Text("Add Item"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5)),
                  onPressed: () {},
                ),
                MaterialButton(
                  onPressed: () async {
                    bool isAllowPermission = await _askPermissions();
                    if (isAllowPermission) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectCustomerPage()),
                      ).then((value) {
                        if (value == "CLEAR")
                          ref
                              .read(orderPageViewModelProvider)
                              .payToChange(null);
                        else if (value != null)
                          ref
                              .read(orderPageViewModelProvider)
                              .payToChange(value);
                      });
                    }
                  },
                  child: Text("Sold to"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(width: 1.5)),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  onPressed: allOrder.length <= 1
                      ? null
                      : () => ref
                          .read(orderPageViewModelProvider)
                          .onPageChange(OrderPageAction.PREVIOUS),
                  shape: CircleBorder(
                      side: BorderSide(
                          width: 1.5,
                          color: allOrder.length <= 1
                              ? Colors.black38
                              : Colors.black)),
                  child: Icon(Icons.navigate_before),
                ),
                Row(
                  children: [
                    Tooltip(
                      child: InkWell(
                        onTap:
                            (order != null ? order.list?.isEmpty ?? true : true)
                                ? null
                                : () => ref
                                    .read(orderPageViewModelProvider)
                                    .clearOrder(),
                        child: Container(
                          child: Icon(Icons.clear,
                              color: (order != null
                                      ? order.list?.isEmpty ?? true
                                      : true)
                                  ? Colors.black38
                                  : Colors.deepOrange),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  width: 1.5,
                                  color: (order != null
                                          ? order.list?.isEmpty ?? true
                                          : true)
                                      ? Colors.black38
                                      : Colors.deepOrange)),
                          padding: EdgeInsets.all(4.5),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      message: "Clear all items in this order",
                    ),
                    SizedBox(width: 24.0),
                    Tooltip(
                      child: InkWell(
                        onTap: allOrder.length <= 1
                            ? null
                            : () => showDeleteOrderDialog(ref),
                        child: Container(
                          child: Icon(Icons.delete,
                              color: allOrder.length <= 1
                                  ? Colors.black38
                                  : Colors.red),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  width: 1.5,
                                  color: allOrder.length <= 1
                                      ? Colors.black38
                                      : Colors.red)),
                          padding: EdgeInsets.all(4.5),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      message: "Delete this order",
                    ),
                    SizedBox(width: 24.0),
                    Tooltip(
                      child: InkWell(
                        // onTap: allOrder.length == 1 &&
                        //         (allOrder.first.list?.isEmpty ?? true)
                        //     ? null
                        //     : () => exportsOrder(),
                        onTap: () {},
                        child: Container(
                          child: Icon(Icons.note,
                              color: allOrder.length == 1 &&
                                      (allOrder.first.list?.isEmpty ?? true)
                                  ? Colors.black38
                                  : Colors.blue),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              border: Border.all(
                                  width: 1.5,
                                  color: allOrder.length == 1 &&
                                          (allOrder.first.list?.isEmpty ?? true)
                                      ? Colors.black38
                                      : Colors.blue)),
                          padding: EdgeInsets.all(4.5),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      message: "Export to memo",
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: allOrder.length <= 1
                      ? null
                      : () => ref
                          .read(orderPageViewModelProvider)
                          .onPageChange(OrderPageAction.NEXT),
                  shape: CircleBorder(
                      side: BorderSide(
                          width: 1.5,
                          color: allOrder.length <= 1
                              ? Colors.black38
                              : Colors.black)),
                  child: Icon(Icons.navigate_next),
                ),
              ],
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

// Future<void> clearOrder() async {
//   String t = await showDialog(
//           context: context,
//           builder: (BuildContext context) =>
//               YesNoDialog(title: "Clear all item in this order")) ??
//       "Cancel";
//   if (t == "Yes") {
//     orderBloc.clearOrder();
//   }
// }
//
  Future<void> showDeleteOrderDialog(WidgetRef ref) async {
    String t = await showDialog(
            context: context,
            builder: (BuildContext context) => DeleteOrderDialog()) ??
        "Cancel";
    if (t == "Delete") {
      String t = await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  YesNoDialog(title: "Delete this order ?")) ??
          "Cancel";
      if (t == "Yes") ref.read(orderPageViewModelProvider).deleteOrderHead();
    } else if (t == "DeleteAll") {
      String t = await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  YesNoDialog(title: "Delete all orders ?")) ??
          "Cancel";
      if (t == "Yes") ref.read(orderPageViewModelProvider).deleteAllOrder();
    }
  }

// Future<void> exportsOrder() async {
//   String isJustOrders = "isJustOrders";
//   String isJustSummary = "isJustSummary";
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool justOrders = prefs.getBool(isJustOrders) ?? true;
//   bool justSummary = prefs.getBool(isJustSummary) ?? true;
//   dynamic t = await showDialog(
//           context: context,
//           builder: (BuildContext context) => ExportsDialog(
//               justOrders: justOrders, justSummary: justSummary)) ??
//       "Cancel";
//   if (t is List<bool>) {
//     orderBloc.exports(t);
//     prefs.setBool(isJustOrders, t[0]);
//     prefs.setBool(isJustSummary, t[1]);
//   }
// }
//
// Future<void> databaseManagement() async {
//   double w = MediaQuery.of(context).size.width / 3;
//   String databasePath =
//       await getDatabasesPath(); //returns a directory which stores permanent files
//   await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 width: w,
//                 height: w,
//                 child: InkWell(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.arrow_circle_up, size: 40.0),
//                       SizedBox(height: 8.0),
//                       Text("Export")
//                     ],
//                   ),
//                   onTap: () async {
//                     Share.shareFiles(
//                       ['$databasePath/database.db'],
//                       subject: 'Database',
//                     );
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//               SizedBox(
//                 width: w,
//                 height: w,
//                 child: InkWell(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.arrow_circle_down, size: 40.0),
//                       SizedBox(height: 8.0),
//                       Text("Import")
//                     ],
//                   ),
//                   onTap: () async {
//                     Navigator.of(context).pop();
//
//                     FilePickerResult? result =
//                         await FilePicker.platform.pickFiles();
//
//                     if (result != null) {
//                       File file = File(result.files.single.path ?? "");
//                       await LocalDatabaseHelper.db.closeDb();
//                       await file.copy('$databasePath/database.db');
//                       await LocalDatabaseHelper.db.database;
//                       await orderBloc.getOrders();
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         );
//       });
// }
//
  Future<bool> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    bool isAllowPermission = permissionStatus == PermissionStatus.granted;
    if (!isAllowPermission) {
      _handleInvalidPermissions(permissionStatus);
    }
    return isAllowPermission;
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(
        content: Text('Access to contact data denied'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        duration: Duration(milliseconds: 1200),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(
        content: Text('Please allow access to contact in setting'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        duration: Duration(milliseconds: 1200),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
