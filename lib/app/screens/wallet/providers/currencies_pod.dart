import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/currency_model.dart';
import 'assets_spod.dart';
import 'balances_spod.dart';
import 'converter_map_fpod.dart';
import 'prices_spod.dart';

final currenciesPod = Provider<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final prices = ref.watch(pricesSpod);
  final converter = ref.watch(converterMapFpod);

  final currencies = <CurrencyModel>[];

  assets.whenData((value) {
    for (final asset in value.assets) {
      currencies.add(
        CurrencyModel(
          symbol: asset.symbol,
          description: asset.description,
          accuracy: asset.accuracy,
          depositMode: asset.depositMode,
          withdrawalMode: asset.withdrawalMode,
          tagType: asset.tagType,
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

  prices.whenData((pricesData) {
    converter.whenData((converterData) {
      if (currencies.isNotEmpty) {
        for (final currency in currencies) {
          final index = currencies.indexOf(currency);

          final baseBalance = currencies[index].calculateBaseBalance(
            prices: pricesData,
            currencies: currencies,
            converter: converterData,
          );

          currencies[index] = currency.copyWith(
            baseBalance: baseBalance,
          );
        }
      }
    });
  });

  return currencies;
});
