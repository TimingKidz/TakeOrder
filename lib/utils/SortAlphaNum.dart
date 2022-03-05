int sortAlphaNum(String a, String b) {
  var reAlpha = RegExp(r'[0-9]');
  var reNum = RegExp(r'[^0-9]');

  var aAlpha = a.replaceAll(reAlpha, "");
  var bAlpha = b.replaceAll(reAlpha, "");

  if (aAlpha == bAlpha && aAlpha is int && bAlpha is int) {
    var aNum = int.parse(a.replaceAll(reNum, ""));
    var bNum = int.parse(b.replaceAll(reNum, ""));
    return aNum.compareTo(bNum);
  }
  return aAlpha.compareTo(bAlpha);
}
