import '../../../models/currency_model.dart';

CurrencyModel currencyFrom(List<CurrencyModel> currencies, String symbol) {
  return currencies.firstWhere(
    (currency) => currency.symbol == symbol,
    orElse: () {
      return const CurrencyModel();
    },
  );
}
