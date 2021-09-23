String formatPriceValue({
  String? prefix,
  num? value,
  String? symbol,
  int? accuracy,
}) {
  if (value != null) {
    final validatedAccuracy = accuracy ?? 2;
    final absValue = value.abs().toStringAsFixed(validatedAccuracy);
    var formattedSymbol = '';

    if (symbol != null) {
      formattedSymbol = ' $symbol';
    }

    if (value.isNegative) {
      return '-$prefix$absValue$symbol';
    }
    return '${prefix ?? ''}$value$formattedSymbol';
  }

  return '';
}
