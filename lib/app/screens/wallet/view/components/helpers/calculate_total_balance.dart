import '../../../models/currency_model.dart';

double calculateTotalBalance(List<CurrencyModel> currencies) {
  var value = 0.0;

  for (final currency in currencies) {
    value = value + currency.baseBalance;
  }

  return double.parse(value.toStringAsFixed(2));
}
