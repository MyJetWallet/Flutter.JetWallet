import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

class PreviewConvertInput {

  PreviewConvertInput({
    required this.fromAmount,
    required this.toAmount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.toAssetEnabled,
    required this.price,
  });
  String fromAmount;
  String toAmount;
  CurrencyModel fromCurrency;
  CurrencyModel toCurrency;
  bool toAssetEnabled;
  Decimal price;

  @override
  String toString() {
    return 'PreviewConvertInput(fromAmount: $fromAmount, toAmount: $toAmount, fromCurrency: $fromCurrency, toCurrency: $toCurrency, toAssetEnabled: $toAssetEnabled, price: $price)';
  }
}
