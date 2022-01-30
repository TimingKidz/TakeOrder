import 'package:invoice_manage/model/memoList.dart';
import 'package:invoice_manage/providers/db_provider.dart';

class Memo {
  int? memoID;
  bool isMemoEdited;
  String? memoContent;
  int? memoCateID;
  String? memoCateName;
  List<MemoList>? list;

  Memo(
      {this.memoID,
      required this.isMemoEdited,
      this.memoContent,
      this.memoCateID,
      this.memoCateName,
      this.list});

  factory Memo.fromMap(Map<String, dynamic> json) {
    return Memo(
        memoID: json[DbProvider.memoID],
        isMemoEdited: json[DbProvider.isMemoEdited] == 1,
        memoContent: json[DbProvider.memoContent],
        memoCateID: json[DbProvider.memoCateID],
        memoCateName: json[DbProvider.cateName],
        list: []);
  }

  Map<String, dynamic> toMap() =>
      {
        DbProvider.memoID: memoID,
        DbProvider.isMemoEdited: isMemoEdited ? 1 : 0,
        DbProvider.memoContent: memoContent,
        DbProvider.memoCateID: memoCateID
      };
}