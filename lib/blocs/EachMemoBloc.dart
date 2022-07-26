import 'dart:async';

import 'package:invoice_manage/features/memo/domain/memo.dart';
import 'package:invoice_manage/providers/memo_provider.dart';

class EachMemoBloc {
  EachMemoBloc(Memo memo) {
    getMemo(memo);
  }

  List<Memo> all = [];
  List<Memo> focus = [];
  String dropdownValue = "All";
  late Memo fMemo;
  Memo? fMemoEdited;

  final _memoController = StreamController<Memo>.broadcast();
  final _isShowKeyboardController = StreamController<bool>.broadcast();

  get memo => _memoController.stream;

  get isShowKeyboard => _isShowKeyboardController.stream;

  getMemo(Memo memo) async {
    fMemo = memo;
    _memoController.sink.add(memo);
  }

  Future<void> update() async {
    await MemoDbProvider.db.updateMemo(fMemo, fMemoEdited!);
  }

  Future<void> delete(Memo memo) async {
    await MemoDbProvider.db.deleteMemo(memo);
  }

  void isShowKeyboardToggle(bool isShow) {
    _isShowKeyboardController.sink.add(isShow);
  }

  void setMemoCategory(String cateName, int cateID) {
    if (fMemoEdited == null) {
      fMemoEdited = fMemo;
      fMemoEdited?.isMemoEdited = true;
    }
    fMemoEdited?.memoCateName = cateName;
    fMemoEdited?.memoCateID = cateID;
    _memoController.sink.add(fMemoEdited!);
  }

  void setMemoContent(String content) {
    if (fMemoEdited == null) {
      fMemoEdited = fMemo;
      fMemoEdited?.isMemoEdited = true;
    }
    fMemoEdited?.memoContent = content;
  }

  dispose() {
    _memoController.close();
    _isShowKeyboardController.close();
  }
}
