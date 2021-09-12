import '../../../shared/models/currency_model.dart';

CurrencyModel currencyFrom(List<CurrencyModel> currencies, String symbol) {
  return currencies.firstWhere((currency) => currency.symbol == symbol);
}
