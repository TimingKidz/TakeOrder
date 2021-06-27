import 'package:invoice_manage/providers/db_provider.dart';

class Item {
  int? itemID;
  late String itemName;
  late double itemPrice;

  Item({
    this.itemID,
    required this.itemName,
    required this.itemPrice
  });

  factory Item.fromMap(Map<String, dynamic> json){
    return Item(
      itemID: json[DbProvider.itemID],
      itemName: json[DbProvider.itemName],
      itemPrice: json[DbProvider.itemPrice]
    );
  }

  Map<String, dynamic> toMap() => {
    DbProvider.itemID: itemID,
    DbProvider.itemName: itemName,
    DbProvider.itemPrice: itemPrice
  };
}