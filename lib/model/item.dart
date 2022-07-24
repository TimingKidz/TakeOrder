import 'package:invoice_manage/core/local_database_helper.dart';

import '../core/constants/database_constants.dart';

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
        itemID: json[DatabaseConstants.itemID],
        itemName: json[DatabaseConstants.itemName],
        itemPrice: json[DatabaseConstants.itemPrice],
        isSelected: false);
  }

  Map<String, dynamic> toMap() => {
        DatabaseConstants.itemID: itemID,
        DatabaseConstants.itemName: itemName,
        DatabaseConstants.itemPrice: itemPrice
      };
}
