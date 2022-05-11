import '../models/currency_model.dart';

bool supportsRecurringBuy(String symbol, List<CurrencyModel> currencies) {
  final symbols = <String>[];

  for (final currency in currencies) {
    if (currency.isAssetBalanceNotEmpty) {
      symbols.add(currency.symbol);
    }
  }

  if (symbols.isEmpty) {
    return false;
  } else if (symbols.length == 1) {
    return !symbols.contains(symbol);
  } else {
    return true;
  }
}
