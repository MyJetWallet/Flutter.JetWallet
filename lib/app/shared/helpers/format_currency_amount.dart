String formatCurrencyAmount({
  String? prefix,
  required num value,
  required String symbol,
  required int accuracy,
}) {
  final absValue = value.abs().toStringAsFixed(accuracy);

  if (value.isNegative) {
    if (prefix == null) {
      return '-$absValue $symbol';
    } else {
      return '-$prefix$absValue';
    }
  } else {
    if (prefix == null) {
      return '$absValue $symbol';
    } else {
      return '$prefix$absValue';
    }
  }
}
