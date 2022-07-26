import 'package:invoice_manage/core/constants/database_constants.dart';

class MemoList {
  late int memoID;
  late String memoItemName;
  late double memoItemPrice;

  MemoList(
      {required this.memoID,
      required this.memoItemName,
      required this.memoItemPrice});

  factory MemoList.fromMap(Map<String, dynamic> json) {
    return MemoList(
        memoID: json[DatabaseConstants.memoID],
        memoItemName: json[DatabaseConstants.memoItemName],
        memoItemPrice: json[DatabaseConstants.memoItemPrice]);
  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.memoID: memoID,
        DatabaseConstants.memoItemName: memoItemName,
        DatabaseConstants.memoItemPrice: memoItemPrice
      };
}
