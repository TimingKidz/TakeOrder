extension Formatters on double {
  String priceStringFormatter() {
    List<String> splitNumber = this.toString().split(".");
    var number = splitNumber.first;
    var decimal = int.parse(splitNumber.last);

    if (decimal == 0)
      return number;
    else
      return this.toString();
  }
}
