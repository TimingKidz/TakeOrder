String textFieldPriceFormatter(double price) {
  List<String> splitNumber = price.toString().split(".");
  var number = splitNumber.first;
  var decimal = int.parse(splitNumber.last);

  if(decimal == 0) return number;
  else return price.toString();
}