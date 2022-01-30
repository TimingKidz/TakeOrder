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
  List<Memo> editedList = [];
  List<Memo> exportList = [];
  String dropdownValue = "All";
  String _searchFilterText = "";

  final _memoController = StreamController<List<Memo>>.broadcast();
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get memo => _memoController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getMemo() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    all = await MemoDbProvider.db.getAllMemo();

    // Find edited item and add to editedList
    editedList = all.where((Memo memo) => memo.isMemoEdited).toList();
    // Sort edited item list
    editedList.sort((a, b) => sortAlphaNum(
        memoTitle(a.memoContent ?? ""), memoTitle(b.memoContent ?? "")));

    // Find export item and add to exportList
    exportList = all.where((Memo memo) => !memo.isMemoEdited).toList();

    // Combined two list
    all.clear();
    all.addAll(editedList);
    all.addAll(exportList);

    String f = prefs?.getString("memoCate") ?? "All";
    dropdownValue = f;
    filter();
  }

  Future<void> add(Memo memo) async {
    await MemoDbProvider.db.newMemo(memo);
    await getMemo();
  }

  Future<void> searchFilter(String s) async {
    _searchFilterText = s;
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

      if (_searchFilterText.isNotEmpty) {
        searchFilter(_searchFilterText);
      } else {
        _memoController.sink.add(all);
      }
    }else if(dropdownValue == "Unfiled"){
      List<Memo> filter =
          all.where((memo) => memo.memoCateName == null).toList();
      focus = filter;

      if (_searchFilterText.isNotEmpty) {
        searchFilter(_searchFilterText);
      } else {
        _memoController.sink.add(filter);
      }
    } else {
      List<Memo> filter =
          all.where((memo) => memo.memoCateName == dropdownValue).toList();
      focus = filter;

      if (_searchFilterText.isNotEmpty) {
        searchFilter(_searchFilterText);
      } else {
        _memoController.sink.add(filter);
      }
    }
    await prefs?.setString("memoCate", dropdownValue);
  }

  String memoTitle(String s) {
    List<String> titleList = s.split("\n");
    for (var i = 0; i < titleList.length; i++) {
      if (titleList[i].isNotEmpty) {
        s = titleList[i];
        break;
      }
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