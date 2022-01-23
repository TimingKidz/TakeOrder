import 'package:invoice_manage/providers/db_provider.dart';

class Item {
  int? itemID;
  late String itemName;
  late double itemPrice;
  bool? isSelected;

  Item(
      {this.itemID,
      required this.itemName,
      required this.itemPrice,
      this.isSelected});

  factory Item.fromMap(Map<String, dynamic> json) {
    return Item(
        itemID: json[DbProvider.itemID],
        itemName: json[DbProvider.itemName],
        itemPrice: json[DbProvider.itemPrice],
        isSelected: false);
  }

  Map<String, dynamic> toMap() => {
    DbProvider.itemID: itemID,
    DbProvider.itemName: itemName,
    DbProvider.itemPrice: itemPrice
  };
}