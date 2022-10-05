import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/core/localdatabase/shared_pref_provider.dart';
import 'package:invoice_manage/features/order/domain/order_page_action.dart';

import '../../../model/item.dart';
import '../data/order_local_provider.dart';
import '../domain/entities/order.dart';
import '../domain/entities/order_list.dart';
import 'order_provider.dart';

class OrderPageViewModel {
  OrderPageViewModel({required this.ref});

  final Ref ref;

  Order get _currentItem {
    final orders = ref.watch(allOrdersProvider);
    final pageNum = ref.watch(orderPageNumProvider);
    return orders.elementAt(pageNum - 1);
  }

  int get _currentPageNum => ref.watch(orderPageNumProvider);

  void _setPageNumberAndSave(int page) {
    final prefs = ref.watch(sharedPrefProvider);
    final pageNum = ref.watch(orderPageNumProvider.notifier);

    pageNum.state = page;
    prefs.value?.setInt("page", page);
  }

  Future<void> getAllOrdersProvider() async {
    final prefs = ref.watch(sharedPrefProvider);
    final pageNum = ref.watch(orderPageNumProvider.notifier);
    final orders = ref.watch(allOrdersProvider.notifier);
    final selectOrder = ref.watch(selectOrderProvider.notifier);

    pageNum.state = prefs.value?.getInt("page") ?? 1;

    List<Order> result =
        await ref.watch(orderLocalDataSourceProvider).getAllOrders();

    selectOrder.state = result.elementAt(pageNum.state - 1);

    print(selectOrder.state?.orderID);

    orders.state = result;
  }

  Future<bool> addOrderHead() async {
    bool _isEmpty = false;

    ref.read(allOrdersProvider).forEach((order) {
      if (order.list?.isEmpty ?? true) _isEmpty = true;
    });

    if (!_isEmpty) {
      await ref.watch(orderLocalDataSourceProvider).addOrderHead();
      _setPageNumberAndSave(ref.read(allOrdersProvider).length + 1);
      getAllOrdersProvider();
      return false;
    } else {
      return true;
    }
  }

  Future<void> clearOrder() async {
    await ref
        .watch(orderLocalDataSourceProvider)
        .clearOrder(_currentItem.orderID);
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateTotal(_currentItem.orderID, 0);
    getAllOrdersProvider();
  }

  Future<void> deleteOrderHead() async {
    final pageNum = ref.watch(orderPageNumProvider.notifier);

    await ref
        .watch(orderLocalDataSourceProvider)
        .deleteOrderHead(_currentItem.orderID);
    if (pageNum.state > 1) {
      _setPageNumberAndSave(pageNum.state - 1);
    }
    getAllOrdersProvider();
  }

  Future<void> deleteAllOrder() async {
    await ref.watch(orderLocalDataSourceProvider).deleteAllOrder();
    _setPageNumberAndSave(1);
    getAllOrdersProvider();
  }

  Future<void> addAllToOrder(List<Item> itemList, int qty) async {
    double itemAllTotal = 0;
    int _orderId = _currentItem.orderID;
    await Future.forEach(itemList, (Item item) async {
      var orderItem = OrderList(
          orderID: _orderId,
          itemID: item.itemID ?? -1,
          itemName: item.itemName,
          listPrice: item.itemPrice,
          qty: qty);
      double itemTotal =
          await ref.watch(orderLocalDataSourceProvider).newItem(orderItem);
      itemAllTotal = itemAllTotal + itemTotal;
    });
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateTotal(_orderId, _currentItem.total + itemAllTotal);
    getAllOrdersProvider();
  }

  Future<void> add(OrderList orderItem) async {
    double itemTotal =
        await ref.watch(orderLocalDataSourceProvider).newItem(orderItem);
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateTotal(orderItem.orderID, _currentItem.total + itemTotal);
    getAllOrdersProvider();
  }

  Future<void> update(OrderList upItem, double listPrice, int qty) async {
    double oldValue = upItem.listPrice * upItem.qty;
    double value = await ref
        .watch(orderLocalDataSourceProvider)
        .updateItem(upItem, listPrice, qty);
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateTotal(upItem.orderID, _currentItem.total - oldValue + value);
    getAllOrdersProvider();
  }

  Future<void> delete(OrderList orderItem) async {
    double value =
        await ref.watch(orderLocalDataSourceProvider).deleteItem(orderItem);
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateTotal(orderItem.orderID, _currentItem.total - value);
    getAllOrdersProvider();
  }

  Future<void> payTypeChange(String type) async {
    await ref
        .watch(orderLocalDataSourceProvider)
        .updatePayType(_currentItem.orderID, type);
    getAllOrdersProvider();
  }

  Future<void> payToChange(dynamic cusID) async {
    await ref
        .watch(orderLocalDataSourceProvider)
        .updateSoldTo(_currentItem.orderID, cusID);
    getAllOrdersProvider();
  }

  void onPageChange(OrderPageAction action) {
    final orders = ref.watch(allOrdersProvider);
    if (action == OrderPageAction.PREVIOUS && !(_currentPageNum <= 0)) {
      _setPageNumberAndSave(_currentPageNum - 1);
    } else if (action == OrderPageAction.NEXT &&
        !(_currentPageNum >= orders.length)) {
      _setPageNumberAndSave(_currentPageNum + 1);
    }
  }

  // Future<void> exports(List<bool> options) async {
  //   bool justOrders = options[0];
  //   bool justSummary = options[1];
  //   int index = 1;
  //   Future.forEach(all, (Order element) async {
  //     if (justOrders) {
  //       if (element.list.isEmpty) return;
  //       String title = "Order#: ${index++}\n";
  //       String orders = "";
  //       element.list.forEach((element) {
  //         orders +=
  //         "${element.qty},${element.itemName},${element.listPrice},${element.listPrice * element.qty}\n";
  //       });
  //       String order = "Date: ${dateFormat(element.date)}\n"
  //           "${element.soldTo != null ? 'Sold to: ${element.soldTo}\n'
  //       // 'Name: ${element.cusName}\n'
  //       // '${element.address != "" ? "${element.address}\n" : ""}'
  //           : ''}"
  //           "Payment: ${element.payType}\n\n"
  //           "$orders"
  //           "\nTOTAL: ${element.total}";
  //       String content = title + order;
  //       Memo m = Memo(
  //         isMemoEdited: false,
  //         memoContent: content,
  //       );
  //       await MemoDbProvider.db.newMemo(m); // Each order memo
  //     }
  //   }).then((_) => {if (justSummary) _exportSummary()});
  // }

  // Future<void> _exportSummary() async {
  //   Summary info = await OrderDbProvider.db.getSummary();
  //   String title = "SALES SUMMARY FOR ${dateFormat(DateTime.now())}\n";
  //   String order = "";
  //   info.orderItemList.forEach((OrderItem each) {
  //     order += "${each.qty},${each.itemName},${each.subTotal}\n";
  //   });
  //
  //   String payTypeTotal =
  //       "  Cash Total: ${info.payTypeTotalMap["Cash Sale"] ?? 0.0}\n"
  //       "  Invoice Total: ${info.payTypeTotalMap["Invoice"] ?? 0.0}\n";
  //
  //   String content = title + order + "TOTAL: ${info.totals}\n" + payTypeTotal;
  //   Memo m = Memo(
  //     isMemoEdited: false,
  //     memoContent: content,
  //   );
  //   await MemoDbProvider.db.newMemo(m); // Summary memo
  // }

  String dateFormat(DateTime date) {
    return DateFormat('d/M/yy, HH:mm').format(date).toString();
  }
}
