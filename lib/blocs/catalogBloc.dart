import 'dart:async';

import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/providers/catalog_provider.dart';

class CatalogBloc {
  CatalogBloc() {
    getCatalog();
  }
  
  List<Item> all = [];

  final _catalogController = StreamController<List<Item>>.broadcast();

  get catalog => _catalogController.stream;

  getCatalog() async {
    all = await CatalogDbProvider.db.getAllCatalog();
    _catalogController.sink.add(all);
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
    if (s.isNotEmpty) {
      List<Item> filter = all.where((item) {
        var title = item.itemName.toLowerCase();
        return title.contains(s);
      }).toList();
      filter.sort(
          (a, b) => a.itemName.indexOf(s).compareTo(b.itemName.indexOf(s)));
      _catalogController.sink.add(filter);
    }else{
      _catalogController.sink.add(all);
    }
  }

  dispose() {
    _catalogController.close();
  }
}