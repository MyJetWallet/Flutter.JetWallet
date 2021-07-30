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