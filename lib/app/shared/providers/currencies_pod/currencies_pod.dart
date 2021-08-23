import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helpers/calculate_base_balance.dart';
import '../../helpers/valid_icon_url.dart';
import '../../models/currency_model.dart';
import '../base_currency_pod/base_currency_pod.dart';
import '../signal_r/assets_spod.dart';
import '../signal_r/balances_spod.dart';
import '../signal_r/base_prices_spod.dart';

final currenciesPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final baseCurrency = ref.watch(baseCurrencyPod);
  final basePrices = ref.watch(basePricesSpod);

  final currencies = <CurrencyModel>[];

  assets.whenData((value) {
    for (final asset in value.assets) {
      currencies.add(
        CurrencyModel(
          symbol: asset.symbol,
          description: asset.description,
          accuracy: asset.accuracy.toInt(),
          depositMode: asset.depositMode,
          withdrawalMode: asset.withdrawalMode,
          tagType: asset.tagType,
          type: asset.type,
          depositMethods: asset.depositMethods,
          fees: asset.fees,
          withdrawalMethods: asset.withdrawalMethods,
          iconUrl: validIconUrl(asset.iconUrl),
          assetId: 'unknown',
          reserve: 0.0,
          lastUpdate: 'unknown',
          sequenceId: 0.0,
          assetBalance: 0.0,
          baseBalance: 0.0,
        ),
      );
    }
  });

  balances.whenData((value) {
    if (currencies.isNotEmpty) {
      for (final balance in value.balances) {
        for (final currency in currencies) {
          if (currency.symbol == balance.assetId) {
            final index = currencies.indexOf(currency);

            currencies[index] = currency.copyWith(
              assetId: balance.assetId,
              reserve: balance.reserve,
              lastUpdate: balance.lastUpdate,
              sequenceId: balance.sequenceId,
              assetBalance: balance.balance,
            );
          }
        }
      }
    }
  });

  basePrices.whenData((data) {
    if (currencies.isNotEmpty) {
      for (final currency in currencies) {
        final index = currencies.indexOf(currency);

        final baseBalance = calculateBaseBalance(
          accuracy: baseCurrency.accuracy,
          assetSymbol: currency.symbol,
          assetBalance: currency.assetBalance,
          prices: data.basePrices,
        );

        currencies[index] = currency.copyWith(
          baseBalance: baseBalance,
        );
      }
    }
  });

  return currencies;
});
