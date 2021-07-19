import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/market_item_model.dart';
import 'assets_spod.dart';
import 'market_references_spod.dart';
import 'prices_spod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final marketReferences = ref.watch(marketReferencesSpod);
  final assets = ref.watch(assetsSpod);
  final prices = ref.watch(pricesSpod);

  final marketItems = <MarketItemModel>[];

  marketReferences.whenData((value) {
    for (final marketReference in value.references) {
      marketItems.add(
        MarketItemModel(
          iconUrl: marketReference.iconUrl ?? 'https://i.imgur.com/cvNa7tH.png',
          weight: marketReference.weight,
          associateAsset: marketReference.associateAsset,
          associateAssetPair: marketReference.associateAssetPair,
          id: '',
          name: '',
          dayPercentChange: 0,
          lastPrice: 0,
        ),
      );
    }
  });

  assets.whenData((value) {
    if (marketItems.isNotEmpty) {
      for (final asset in value.assets) {
        for (final marketItem in marketItems) {
          if (marketItem.associateAsset == asset.symbol) {
            final index = marketItems.indexOf(marketItem);

            marketItems[index] = marketItem.copyWith(
              id: asset.symbol,
              name: asset.description,
            );
          }
        }
      }
    }
  });

  prices.whenData((value) {
    if (marketItems.isNotEmpty) {
      for (final price in value.prices) {
        for (final marketItem in marketItems) {
          if (marketItem.associateAssetPair == price.id) {
            final index = marketItems.indexOf(marketItem);

            marketItems[index] = marketItem.copyWith(
              dayPercentChange: price.dayPercentageChange,
              lastPrice: price.lastPrice
            );
          }
        }
      }
    }
  });

  marketItems.sort((a, b) => b.weight.compareTo(a.weight));

  return marketItems;
});
