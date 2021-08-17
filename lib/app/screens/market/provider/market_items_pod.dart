import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/valid_icon_url.dart';
import '../helper/accuracy_from.dart';
import '../helper/calculate_base_balance.dart';
import '../model/market_item_model.dart';
import 'assets_spod.dart';
import 'balances_spod.dart';
import 'converter_map_fpod.dart';
import 'instruments_spod.dart';
import 'market_references_spod.dart';
import 'prices_spod.dart';
import 'search_stpod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final references = ref.watch(marketReferencesSpod);
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final instruments = ref.watch(instrumentsSpod);
  final prices = ref.watch(pricesSpod);
  final search = ref.watch(searchStpod);
  final converter = ref.watch(converterMapFpod);

  final items = <MarketItemModel>[];

  references.whenData((value) {
    for (final marketReference in value.references) {
      items.add(
        MarketItemModel(
          iconUrl: validIconUrl(marketReference.iconUrl),
          weight: marketReference.weight,
          associateAsset: marketReference.associateAsset,
          associateAssetPair: marketReference.associateAssetPair,
          id: '',
          name: '',
          dayPriceChange: 0,
          dayPercentChange: 0,
          lastPrice: 0,
          assetBalance: 0,
          baseBalance: 0,
        ),
      );
    }
  });

  assets.whenData((value) {
    if (items.isNotEmpty) {
      for (final asset in value.assets) {
        for (final marketItem in items) {
          if (marketItem.associateAsset == asset.symbol) {
            final index = items.indexOf(marketItem);

            items[index] = marketItem.copyWith(
              id: asset.symbol,
              name: asset.description,
            );
          }
        }
      }
    }
  });

  balances.whenData((value) {
    if (items.isNotEmpty) {
      for (final balance in value.balances) {
        for (final marketItem in items) {
          if (marketItem.associateAsset == balance.assetId) {
            final index = items.indexOf(marketItem);

            items[index] = marketItem.copyWith(
              assetBalance: balance.balance,
            );
          }
        }
      }
    }
  });

  instruments.whenData((instrumentsData) {
    final instruments = instrumentsData.instruments;

    prices.whenData((pricesData) {
      converter.whenData((converterData) {
        if (items.isNotEmpty) {
          for (final item in items) {
            final index = items.indexOf(item);

            final baseBalance = calculateBaseBalance(
              accuracy: accuracyFrom('USD', instruments),
              baseSymbol: 'USD',
              assetSymbol: item.associateAsset,
              assetBalance: item.assetBalance,
              prices: pricesData.prices,
              converter: converterData,
            );

            items[index] = item.copyWith(
              baseBalance: baseBalance,
            );
          }
        }
      });
    });
  });

  prices.whenData((value) {
    if (items.isNotEmpty) {
      for (final price in value.prices) {
        for (final marketItem in items) {
          if (marketItem.associateAssetPair == price.id) {
            final index = items.indexOf(marketItem);

            items[index] = marketItem.copyWith(
              dayPriceChange: price.dayPriceChange,
              dayPercentChange: price.dayPercentageChange,
              lastPrice: price.lastPrice,
            );
          }
        }
      }
    }
  });

  return _formattedItems(items, search.state.text.toLowerCase());
});

List<MarketItemModel> _formattedItems(
  List<MarketItemModel> items,
  String searchInput,
) {
  items.sort((a, b) => b.weight.compareTo(a.weight));

  return items
      .where((item) =>
          item.id.toLowerCase().contains(searchInput) ||
          item.name.toLowerCase().contains(searchInput))
      .toList();
}
