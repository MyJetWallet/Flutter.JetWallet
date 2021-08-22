import '../../../shared/models/currency_model.dart';

double calculateTotalBalance(int accuracy, List<CurrencyModel> currencies) {
  var value = 0.0;

  for (final currency in currencies) {
    if (currency.baseBalance != -1) {
      value = value + currency.baseBalance;
    }
  }

  return double.parse(value.toStringAsFixed(accuracy));
}
