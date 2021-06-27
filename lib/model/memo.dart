import 'package:invoice_manage/model/memoList.dart';
import 'package:invoice_manage/providers/db_provider.dart';

class Memo {
  int? memoID;
  String? memoTitle;
  String? memoContent;
  int? memoCateID;
  String? memoCateName;
  List<MemoList>? list;

  Memo({
    this.memoID,
    this.memoTitle,
    this.memoContent,
    this.memoCateID,
    this.memoCateName,
    this.list
  });

  factory Memo.fromMap(Map<String, dynamic> json) {
    return Memo(
      memoID: json[DbProvider.memoID],
      memoTitle: json[DbProvider.memoTitle],
      memoContent: json[DbProvider.memoContent],
      memoCateID: json[DbProvider.memoCateID],
      memoCateName: json[DbProvider.cateName],
      list: []
    );
  }

  Map<String, dynamic> toMap() => {
    DbProvider.memoID: memoID,
    DbProvider.memoTitle: memoTitle,
    DbProvider.memoContent: memoContent,
    DbProvider.memoCateID: memoCateID
  };
}