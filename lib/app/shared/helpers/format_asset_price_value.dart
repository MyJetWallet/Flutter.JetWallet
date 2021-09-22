const _dollarPrefixSymbol = '\$';
const _euroPrefixSymbol = '€';

String formatPriceValue({
  String? prefix,
  num? value,
  int? accuracy,
}) {
  if (value != null) {
    final validatedAccuracy = accuracy ?? 2;
    final absValue = value.abs().toStringAsFixed(validatedAccuracy);

    if (prefix == 'USD') {
      if (value.isNegative) {
        return '-$_dollarPrefixSymbol$absValue';
      }
      return '$_dollarPrefixSymbol$value';
    } else if (prefix == 'EUR') {
      if (value.isNegative) {
        return '-$_euroPrefixSymbol$absValue';
      }
      return '$_euroPrefixSymbol$value';
    } else {
      return '$value $prefix';
    }
  }

  return '';
}
