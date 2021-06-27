import 'dart:async';

import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/providers/memo_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoBloc {
  MemoBloc() {
    getMemo();
  }

  SharedPreferences? prefs;
  List<Memo> all = [];
  List<Memo> focus = [];
  String dropdownValue = "All";
  late Memo fMemo;

  final _memoController = StreamController<List<Memo>>.broadcast();

  get memo => _memoController.stream;

  getMemo() async {
    if(prefs == null) prefs = await SharedPreferences.getInstance();
    all = await MemoDbProvider.db.getAllMemo();
    String f = prefs?.getString("memoCate") ?? "All";
    dropdownValue = f;
    filter();
  }

  Future<void> add(Memo memo) async {
    await MemoDbProvider.db.newMemo(memo);
    await getMemo();
  }

  Future<void> update(Memo old, Memo up) async {
    await MemoDbProvider.db.updateMemo(old, up);
    await getMemo();
  }

  Future<void> delete(Memo memo) async {
    await MemoDbProvider.db.deleteMemo(memo);
    await getMemo();
  }

  Future<void> searchFilter(String s) async {
    List<Memo> filList = prefs?.getString("memoCate") == "All" ? all : focus;
    if (s.isNotEmpty) {
      List<Memo> filter = filList.where((memo) {
        var title = memo.memoTitle?.toLowerCase() ?? "";
        return title.contains(s);
      }).toList();
      _memoController.sink.add(filter);
    }else{
      _memoController.sink.add(filList);
    }
  }

  Future<void> filter() async {
    if(dropdownValue == "All"){
      focus = all;
      _memoController.sink.add(all);
    }else if(dropdownValue == "Unfiled"){
      List<Memo> filter = all.where((memo) => memo.memoCateName == null).toList();
      focus = filter;
      _memoController.sink.add(filter);
    }else{
      List<Memo> filter = all.where((memo) => memo.memoCateName == dropdownValue).toList();
      focus = filter;
      _memoController.sink.add(filter);
    }
    await prefs?.setString("memoCate", dropdownValue);
  }

  dispose() {
    _memoController.close();
  }
}