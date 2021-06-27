import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invoice_manage/model/catagories.dart';
import 'package:invoice_manage/providers/categories_provider.dart';

class CategoriesBloc {
  CategoriesBloc() {
    getCategories();
  }

  List<Categories> all = [];

  final _categoriesController = StreamController<List<Categories>>.broadcast();

  get categories => _categoriesController.stream;

  getCategories() async {
    all = await CateDbProvider.db.getAllCategories();
    _categoriesController.sink.add(all);
  }

  Future<void> add(Categories cate) async {
    await CateDbProvider.db.newCate(cate);
    await getCategories();
  }

  Future<void> update(Categories old, Categories up) async {
    await CateDbProvider.db.updateCate(old, up);
    await getCategories();
  }

  Future<void> delete(Categories cate) async {
    await CateDbProvider.db.deleteCate(cate);
    await getCategories();
  }

  List<DropdownMenuItem<String>> genDropdownMenu() {
    List<DropdownMenuItem<String>> cate = all.map((Categories c) {
      return DropdownMenuItem<String>(
        value: c.cateName,
        child: Text(c.cateName),
      );
    }).toList();
    return cate;
  }

  dispose() {
    _categoriesController.close();
  }
}