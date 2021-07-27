import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../helper/validated_icon_url.dart';

import '../model/market_item_model.dart';
import 'assets_spod.dart';
import 'market_references_spod.dart';
import 'prices_spod.dart';
import 'search_stpod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final references = ref.watch(marketReferencesSpod);
  final assets = ref.watch(assetsSpod);
  final prices = ref.watch(pricesSpod);
  final search = ref.watch(searchStpod);

  final items = <MarketItemModel>[];

  references.whenData((value) {
    for (final marketReference in value.references) {
      items.add(
        MarketItemModel(
          iconUrl: validatedIconUrl(marketReference.iconUrl),
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

  prices.whenData((value) {
    if (items.isNotEmpty) {
      for (final price in value.prices) {
        for (final marketItem in items) {
          if (marketItem.associateAssetPair == price.id) {
            final index = items.indexOf(marketItem);

            items[index] = marketItem.copyWith(
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
