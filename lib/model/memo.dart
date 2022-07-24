import 'package:invoice_manage/model/memoList.dart';

import '../core/constants/database_constants.dart';

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
        memoID: json[DatabaseConstants.memoID],
        isMemoEdited: json[DatabaseConstants.isMemoEdited] == 1,
        memoContent: json[DatabaseConstants.memoContent],
        memoCateID: json[DatabaseConstants.memoCateID],
        memoCateName: json[DatabaseConstants.cateName],
        list: []);
  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.memoID: memoID,
        DatabaseConstants.isMemoEdited: isMemoEdited ? 1 : 0,
        DatabaseConstants.memoContent: memoContent,
        DatabaseConstants.memoCateID: memoCateID
      };
}
