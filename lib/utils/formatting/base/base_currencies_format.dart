
String baseCurrenciesFormat({
  String? prefix,
  required String text,
  required String symbol,
}) {
  return '${prefix ?? ''}$text${prefix == null ? ' $symbol' : ''}';
}
