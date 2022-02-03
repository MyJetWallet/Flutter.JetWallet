import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service/services/signal_r/model/base_prices_model.dart';
import '../providers/base_currency_pod/base_currency_pod.dart';
import '../providers/signal_r/base_prices_spod.dart';

/// Responsible for converting asset balance to the base balance.
/// Doesn't work properly inside currenciesPod and marketItemsPod.
/// In order to make it work, I need to listen for prices (ref.watch) which
/// destroys  the purpose of the function because I still need to reference
/// dependencies of the function and the function was created
/// to reduce them, abstract from them
Decimal calculateBaseBalanceWithReader({
  required Reader read,
  required String assetSymbol,
  required Decimal assetBalance,
}) {
  var baseValue = Decimal.zero;

  read(basePricesSpod).whenData((data) {
    final baseCurrency = read(baseCurrencyPod);

    final assetPrice = basePriceFrom(
      prices: data.prices,
      assetSymbol: assetSymbol,
    );

    baseValue = calculateBaseBalance(
      assetSymbol: assetSymbol,
      assetBalance: assetBalance,
      assetPrice: assetPrice,
      baseCurrencySymbol: baseCurrency.symbol,
    );
  });

  return baseValue;
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
