import '../../../shared/models/currency_model.dart';

double maxCurrencyApy(List<CurrencyModel> currencies) {
  var maxApy = 0.0;
  for (final element in currencies) {
    if (element.apy.toDouble() > maxApy) {
      maxApy = element.apy.toDouble();
    }
  }
  return maxApy;
}
