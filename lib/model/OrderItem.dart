class OrderItem {
  late String itemName;
  late double subTotal;
  late int qty;

  OrderItem(
      {required this.itemName, required this.subTotal, required this.qty});

  factory OrderItem.fromMap(Map<String, dynamic> json) {
    return OrderItem(
        itemName: json["itemName"],
        subTotal: json["SubTotal"],
        qty: json["qty"]);
  }

  Map<String, dynamic> toMap() =>
      {"itemName": itemName, "SubTotal": subTotal, "qty": qty};
}
