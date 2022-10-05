import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_manage/core/localdatabase/shared_pref_provider.dart';
import 'package:invoice_manage/core/page_state.dart';
import 'package:invoice_manage/features/order/data/order_local_provider.dart';
import 'package:invoice_manage/features/order/domain/entities/order.dart';
import 'package:invoice_manage/features/order/presenter/pages/order_page.dart';

import 'order_page_view_model.dart';

// State Provider
final orderPageProvider = Provider<OrderPage>((ref) => OrderPage());

final orderPageViewModelProvider =
    Provider<OrderPageViewModel>((ref) => OrderPageViewModel(ref: ref));

final orderPageNumProvider = StateProvider<int>((ref) => 1, name: "Order Num");

final orderPageStateProvider = StateProvider<PageState>(
    (ref) => PageState.LOADING,
    name: "Order Page State");

final allOrdersProvider =
    StateProvider<List<Order>>((ref) => <Order>[], name: "All Orders");

final selectOrderProvider = StateProvider<Order?>((ref) => null);

// Future Provider
final getAllOrdersProvider = FutureProvider<void>((ref) async {
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
}, name: "Get All Orders");

final addOrderHead = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPrefProvider);
  final pageNum = ref.watch(orderPageNumProvider.notifier);

  if (ref.read(allOrdersProvider).isEmpty) {
    await ref.watch(orderLocalDataSourceProvider).addOrderHead();
    pageNum.state = ref.read(allOrdersProvider).length + 1;
    prefs.value?.setInt("page", pageNum.state);
    return false;
  } else {
    return true;
  }
});
