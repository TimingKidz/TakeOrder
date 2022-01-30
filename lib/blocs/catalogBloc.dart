import 'dart:async';

import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/providers/catalog_provider.dart';

class CatalogBloc {
  CatalogBloc() {
    getCatalog();
  }

  List<Item> all = [];
  String _searchFilterText = "";

  final _catalogController = StreamController<List<Item>>.broadcast();
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get catalog => _catalogController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getCatalog() async {
    all = await CatalogDbProvider.db.getAllCatalog();
    if (_searchFilterText.isNotEmpty) {
      searchFilter(_searchFilterText);
    } else {
      _catalogController.sink.add(all);
    }
  }

  Future<void> add(Item item) async {
    await CatalogDbProvider.db.newItem(item);
    await getCatalog();
  }

  Future<void> update(Item oldItem, Item upItem) async {
    await CatalogDbProvider.db.updateItem(oldItem, upItem);
    await getCatalog();
  }

  Future<void> delete(Item item) async {
    await CatalogDbProvider.db.deleteItem(item);
    await getCatalog();
  }

  Future<void> searchFilter(String s) async {
    _searchFilterText = s;
    if (s.isNotEmpty) {
      List<Item> filter = all.where((item) {
        var title = item.itemName.toLowerCase();
        return title.contains(s);
      }).toList();
      filter.sort(
          (a, b) => a.itemName.indexOf(s).compareTo(b.itemName.indexOf(s)));
      _catalogController.sink.add(filter);
    } else {
      _catalogController.sink.add(all);
    }
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  dispose() {
    _catalogController.close();
    _isShowKeyboardController.close();
  }
}