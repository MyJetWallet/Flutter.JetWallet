import 'package:decimal/decimal.dart';

import '../../../models/currency_model.dart';

CurrencyModel currencyFrom(List<CurrencyModel> currencies, String symbol) {
  return currencies.firstWhere(
    (currency) => currency.symbol == symbol,
    orElse: () {
      return CurrencyModel(
        assetBalance: Decimal.zero,
        baseBalance: Decimal.zero,
        currentPrice: Decimal.zero,
        dayPriceChange: Decimal.zero,
        assetTotalEarnAmount: Decimal.zero,
        baseTotalEarnAmount: Decimal.zero,
        assetCurrentEarnAmount: Decimal.zero,
        baseCurrentEarnAmount: Decimal.zero,
        apy: Decimal.zero,
        apr: Decimal.zero,
        depositInProcess: Decimal.zero,
      );
    },
  );
}
