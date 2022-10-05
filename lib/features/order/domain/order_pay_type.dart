import 'package:json_annotation/json_annotation.dart';

enum OrderPayType {
  @JsonValue("Cash Sale")
  CASH_SALE,
  @JsonValue("Invoice")
  INVOICE
}

extension OrderPayTypeExtension on OrderPayType {
  String get displayName {
    switch (this) {
      case OrderPayType.CASH_SALE:
        return "Cash Sale";
      case OrderPayType.INVOICE:
        return "Invoice";
    }
  }
}
