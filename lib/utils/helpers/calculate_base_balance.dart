import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:simple_networking/modules/signal_r/models/base_prices_model.dart';

/// Responsible for converting asset balance to the base balance.
/// Doesn't work properly inside currenciesPod and marketItemsPod.
/// In order to make it work, I need to listen for prices (ref.watch) which
/// destroys  the purpose of the function because I still need to reference
/// dependencies of the function and the function was created
/// to reduce them, abstract from them
Decimal calculateBaseBalanceWithReader({
  required String assetSymbol,
  required Decimal assetBalance,
}) {
  final baseCurrency = sSignalRModules.baseCurrency;

  final assetPrice = basePriceFrom(
    prices: sSignalRModules.basePrices.value!.prices,
    assetSymbol: assetSymbol,
  );

  return calculateBaseBalance(
    assetSymbol: assetSymbol,
    assetBalance: assetBalance,
    assetPrice: assetPrice,
    baseCurrencySymbol: baseCurrency.symbol,
  );
}

Decimal calculateBaseBalance({
  required String assetSymbol,
  required Decimal assetBalance,
  required BasePriceModel assetPrice,
  required String baseCurrencySymbol,
}) {
  if (assetSymbol == baseCurrencySymbol) {
    return assetBalance;
  }

  return assetBalance * assetPrice.currentPrice;
}

BasePriceModel basePriceFrom({
  required List<BasePriceModel> prices,
  required String assetSymbol,
}) {
  return prices.firstWhere(
    (element) {
      return element.assetSymbol == assetSymbol;
    },
    orElse: () {
      return BasePriceModel(
        assetSymbol: assetSymbol,
        currentPrice: Decimal.zero,
        dayPriceChange: Decimal.zero,
      );
    },
  );
}
