/// Used for input fields on actions
String formatCurrencyStringAmount({
  String? prefix,
  required String value,
  required String symbol,
}) {
  if (prefix == null) {
    if (symbol == 'USD') {
      return '\$$value';
    } else {
      return '$value $symbol';
    }
  } else {
    return '$prefix$value';
  }
}
