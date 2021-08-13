import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/valid_icon_url.dart';
import '../helper/accuracy_from.dart';
import '../helper/calculate_base_balance.dart';
import '../model/currency_model.dart';
import 'assets_spod.dart';
import 'balances_spod.dart';
import 'converter_map_fpod.dart';
import 'instruments_spod.dart';
import 'market_references_spod.dart';
import 'prices_spod.dart';

final currenciesPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final prices = ref.watch(pricesSpod);
  final instruments = ref.watch(instrumentsSpod);
  final references = ref.watch(marketReferencesSpod);
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
          type: asset.type,
          depositMethods: asset.depositMethods,
          fees: asset.fees,
          withdrawalMethods: asset.withdrawalMethods,
          assetId: 'unknown',
          reserve: 0.0,
          lastUpdate: 'unknown',
          sequenceId: 0.0,
          assetBalance: 0.0,
          baseBalance: 0.0,
          iconUrl: validIconUrl(),
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

  references.whenData((value) {
    if (currencies.isNotEmpty) {
      for (final reference in value.references) {
        for (final currency in currencies) {
          final index = currencies.indexOf(currency);

          currencies[index] = currency.copyWith(
            iconUrl: validIconUrl(reference.iconUrl),
          );
        }
      }
    }
  });

  instruments.whenData((instrumentsData) {
    final instruments = instrumentsData.instruments;

    prices.whenData((pricesData) {
      converter.whenData((converterData) {
        if (currencies.isNotEmpty) {
          for (final currency in currencies) {
            final index = currencies.indexOf(currency);

            final baseBalance = calculateBaseBalance(
              accuracy: accuracyFrom('USD', instruments),
              baseSymbol: 'USD',
              assetSymbol: currency.symbol,
              assetBalance: currency.assetBalance,
              prices: pricesData.prices,
              converter: converterData,
            );

            currencies[index] = currency.copyWith(
              baseBalance: baseBalance,
            );
          }
        }
      });
    });
  });

  return currencies;
});
