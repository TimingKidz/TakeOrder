import 'dart:async';

import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/providers/catalog_provider.dart';

class CatalogBloc {
  CatalogBloc() {
    _isHaveItemSelectedController.sink.add(false);
    getCatalog();
  }

  List<Item> all = [];
  List<Item> selectedItem = [];
  String _searchFilterText = "";

  final _catalogController = StreamController<List<Item>>.broadcast();

  get catalog => _catalogController.stream;

  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get isShowKeyboard => _isShowKeyboardController.stream;

  final _isHaveItemSelectedController = StreamController<bool>.broadcast();

  get isHaveItemSelected => _isHaveItemSelectedController.stream;

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

  void setIsSelected(Item selectItem) {
    all = all.map((Item item) {
      if (item.itemID == selectItem.itemID) {
        var editItem = Item(
            itemID: item.itemID,
            itemName: item.itemName,
            itemPrice: item.itemPrice,
            isSelected: !(item.isSelected ?? true));
        if (item.isSelected ?? true) {
          selectedItem.remove(selectItem);
        } else {
          selectedItem.add(editItem);
        }
        return editItem;
      } else {
        return item;
      }
    }).toList();
    isHaveItemSelectedToggle();
    _catalogController.sink.add(all);
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  void isHaveItemSelectedToggle() {
    _isHaveItemSelectedController.sink.add(selectedItem.isNotEmpty);
  }

  dispose() {
    _catalogController.close();
    _isShowKeyboardController.close();
    _isHaveItemSelectedController.close();
  }
}
