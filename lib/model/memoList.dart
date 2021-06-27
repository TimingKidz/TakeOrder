import 'package:invoice_manage/providers/db_provider.dart';

class MemoList {
  late int memoID;
  late String memoItemName;
  late double memoItemPrice;

  MemoList({
    required this.memoID,
    required this.memoItemName,
    required this.memoItemPrice
  });

  factory MemoList.fromMap(Map<String, dynamic> json) {
    return MemoList(
      memoID: json[DbProvider.memoID],
      memoItemName: json[DbProvider.memoItemName],
      memoItemPrice: json[DbProvider.memoItemPrice]
    );
  }

  Map<String, dynamic> toMap() => {
    DbProvider.memoID: memoID,
    DbProvider.memoItemName: memoItemName,
    DbProvider.memoItemPrice: memoItemPrice
  };
}