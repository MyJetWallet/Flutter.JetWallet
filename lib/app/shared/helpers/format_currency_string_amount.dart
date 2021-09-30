String formatCurrencyStringAmount({
  String? prefix,
  required String value,
  required String symbol,
}) {
  if (prefix == null) {
    return '$value $symbol';
  } else {
    return '$prefix$value';
  }
}
