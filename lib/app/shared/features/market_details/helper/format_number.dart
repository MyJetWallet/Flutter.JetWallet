// This function is used for formatting bug numbers to format k, m, b
// eg. 1000 = 1k, 1 000 000 = 1m, etc
String formatNumber(double num) {
  if (num > 999 && num < 99999) {
    return '${(num / 1000).toStringAsFixed(2)} K';
  } else if (num > 99999 && num < 999999) {
    return '${(num / 1000).toStringAsFixed(0)} K';
  } else if (num > 999999 && num < 999999999) {
    return '${(num / 1000000).toStringAsFixed(2)} M';
  } else if (num > 999999999) {
    return '${(num / 1000000000).toStringAsFixed(2)} B';
  } else {
    return num.toString();
  }
}
