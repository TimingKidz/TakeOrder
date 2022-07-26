import 'dart:async';

import 'package:intl/intl.dart';
import 'package:invoice_manage/features/memo/domain/memo.dart';
import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/model/order.dart';
import 'package:invoice_manage/model/orderList.dart';
import 'package:invoice_manage/model/order_item.dart';
import 'package:invoice_manage/providers/memo_provider.dart';
import 'package:invoice_manage/providers/order_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/summary/domain/entities/summary.dart';

class OrderBloc {
  OrderBloc() {
    getOrders();
  }

  SharedPreferences? prefs;
  List<Order> all = [];
  int pageNum = 1;
  int len = 1;
  bool isEmpty = false;

  final _orderController = StreamController<Order>.broadcast();
  final _orderListController = StreamController<List<OrderList>>.broadcast();
  final _orderNumController = StreamController<int>.broadcast();

  get order => _orderController.stream;

  get orderList => _orderListController.stream;

  get orderNum => _orderNumController.stream;

  getOrders() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    pageNum = prefs?.getInt("page") ?? 1;
    isEmpty = false;
    all = await OrderDbProvider.db.getAllOrders();
    all.forEach((o) {
      if (o.list.isEmpty) {
        isEmpty = true;
      }
    });
    len = all.length;
    _orderController.sink.add(all.elementAt(pageNum - 1));
    _orderListController.sink.add(all.elementAt(pageNum - 1).list);
    _orderNumController.sink.add(pageNum);
  }

  // Order findOrder(int id) {
  //   return all.firstWhere((o) => o.orderID == id);
  // }

  Future<bool> addOrderHead() async {
    if (!isEmpty) {
      await OrderDbProvider.db.addOrderHead();
      pageNum = all.length + 1;
      prefs?.setInt("page", pageNum);
      await getOrders();
      return false;
    } else {
      return true;
    }
  }

  Future<void> clearOrder() async {
    int id = all.elementAt(pageNum - 1).orderID;
    await OrderDbProvider.db.clearOrder(id);
    await OrderDbProvider.db.updateTotal(id, 0);
    await getOrders();
  }

  Future<void> deleteOrderHead() async {
    await OrderDbProvider.db
        .deleteOrderHead(all.elementAt(pageNum - 1).orderID);
    if (pageNum > 1) {
      pageNum -= 1;
      prefs?.setInt("page", pageNum);
    }
    await getOrders();
  }

  Future<void> deleteAllOrder() async {
    await OrderDbProvider.db.deleteAllOrder();
    pageNum = 1;
    prefs?.setInt("page", pageNum);
    await getOrders();
  }

  Future<void> addAllToOrder(List<Item> itemList, int qty) async {
    double itemAllTotal = 0;
    int _orderId = all.elementAt(pageNum - 1).orderID;
    await Future.forEach(itemList, (Item item) async {
      var orderItem = OrderList(
          orderID: _orderId,
          itemID: item.itemID ?? -1,
          itemName: item.itemName,
          listPrice: item.itemPrice,
          qty: qty);
      double itemTotal = await OrderDbProvider.db.newItem(orderItem);
      itemAllTotal = itemAllTotal + itemTotal;
    });
    await OrderDbProvider.db
        .updateTotal(_orderId, all.elementAt(pageNum - 1).total + itemAllTotal);
    await getOrders();
  }

  Future<void> add(OrderList orderItem) async {
    double itemTotal = await OrderDbProvider.db.newItem(orderItem);
    await OrderDbProvider.db.updateTotal(
        orderItem.orderID, all.elementAt(pageNum - 1).total + itemTotal);
    await getOrders();
  }

  Future<void> update(OrderList upItem, double listPrice, int qty) async {
    double oldValue = upItem.listPrice * upItem.qty;
    double value = await OrderDbProvider.db.updateItem(upItem, listPrice, qty);
    await OrderDbProvider.db.updateTotal(
        upItem.orderID, all.elementAt(pageNum - 1).total - oldValue + value);
    await getOrders();
  }

  Future<void> delete(OrderList orderItem) async {
    double value = await OrderDbProvider.db.deleteItem(orderItem);
    await OrderDbProvider.db.updateTotal(
        orderItem.orderID, all.elementAt(pageNum - 1).total - value);
    await getOrders();
  }

  Future<void> payTypeChange(String type) async {
    await OrderDbProvider.db
        .updatePayType(all.elementAt(pageNum - 1).orderID, type);
    await getOrders();
  }

  Future<void> payToChange(dynamic cusID) async {
    await OrderDbProvider.db
        .updateSoldTo(all.elementAt(pageNum - 1).orderID, cusID);
    await getOrders();
  }

  Future<void> incrementPage() async {
    pageNum += 1;
    prefs?.setInt("page", pageNum);
    _orderController.sink.add(all.elementAt(pageNum - 1));
    _orderNumController.sink.add(pageNum);
    _orderListController.sink.add(all.elementAt(pageNum - 1).list);
  }

  Future<void> decrementPage() async {
    pageNum -= 1;
    prefs?.setInt("page", pageNum);
    _orderController.sink.add(all.elementAt(pageNum - 1));
    _orderNumController.sink.add(pageNum);
    _orderListController.sink.add(all.elementAt(pageNum - 1).list);
  }

  Future<void> exports(List<bool> options) async {
    bool justOrders = options[0];
    bool justSummary = options[1];
    int index = 1;
    Future.forEach(all, (Order element) async {
      if (justOrders) {
        if (element.list.isEmpty) return;
        String title = "Order#: ${index++}\n";
        String orders = "";
        element.list.forEach((element) {
          orders +=
              "${element.qty},${element.itemName},${element.listPrice},${element.listPrice * element.qty}\n";
        });
        String order = "Date: ${dateFormat(element.date)}\n"
            "${element.soldTo != null ? 'Sold to: ${element.soldTo}\n'
                // 'Name: ${element.cusName}\n'
                // '${element.address != "" ? "${element.address}\n" : ""}'
                : ''}"
            "Payment: ${element.payType}\n\n"
            "$orders"
            "\nTOTAL: ${element.total}";
        String content = title + order;
        Memo m = Memo(
          isMemoEdited: false,
          memoContent: content,
        );
        await MemoDbProvider.db.newMemo(m); // Each order memo
      }
    }).then((_) => {if (justSummary) _exportSummary()});
  }

  Future<void> _exportSummary() async {
    Summary info = await OrderDbProvider.db.getSummary();
    String title = "SALES SUMMARY FOR ${dateFormat(DateTime.now())}\n";
    String order = "";
    info.orderItemList.forEach((OrderItem each) {
      order += "${each.qty},${each.itemName},${each.subTotal}\n";
    });

    String payTypeTotal =
        "  Cash Total: ${info.payTypeTotalMap["Cash Sale"] ?? 0.0}\n"
        "  Invoice Total: ${info.payTypeTotalMap["Invoice"] ?? 0.0}\n";

    String content = title + order + "TOTAL: ${info.totals}\n" + payTypeTotal;
    Memo m = Memo(
      isMemoEdited: false,
      memoContent: content,
    );
    await MemoDbProvider.db.newMemo(m); // Summary memo
  }

  String dateFormat(DateTime date) {
    return DateFormat('d/M/yy, HH:mm').format(date).toString();
  }

  dispose() {
    _orderController.close();
    _orderListController.close();
    _orderNumController.close();
  }
}
