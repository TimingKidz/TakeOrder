import 'dart:async';

import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/providers/memo_provider.dart';
import 'package:invoice_manage/utils/SortAlphaNum.dart';
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
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get memo => _memoController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getMemo() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    all = await MemoDbProvider.db.getAllMemo();
    all.sort((a, b) => sortAlphaNum(
        memoTitle(a.memoContent ?? ""), memoTitle(b.memoContent ?? "")));
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
        var title = memoTitle(memo.memoContent ?? "").toLowerCase();
        return title.contains(s);
      }).toList();
      filter.sort((a, b) => memoTitle(a.memoContent ?? "")
          .indexOf(s)
          .compareTo(memoTitle(b.memoContent ?? "").indexOf(s)));
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
      List<Memo> filter =
          all.where((memo) => memo.memoCateName == null).toList();
      focus = filter;
      _memoController.sink.add(filter);
    } else {
      List<Memo> filter =
          all.where((memo) => memo.memoCateName == dropdownValue).toList();
      focus = filter;
      _memoController.sink.add(filter);
    }
    await prefs?.setString("memoCate", dropdownValue);
  }

  String memoTitle(String s) {
    int idx = s.indexOf("\n");
    if (idx < 0) {
      // if(s.length > 10) s = s.substring(0, 20).trim();
    } else {
      s = s.substring(0, idx).trim();
    }
    return s;
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  dispose() {
    _memoController.close();
    _isShowKeyboardController.close();
  }
}