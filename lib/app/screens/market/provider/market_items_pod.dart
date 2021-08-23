import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/calculate_base_balance.dart';
import '../../../shared/helpers/valid_icon_url.dart';
import '../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../shared/providers/signal_r/assets_spod.dart';
import '../../../shared/providers/signal_r/balances_spod.dart';
import '../../market_details/provider/base_prices_spod.dart';
import '../model/market_item_model.dart';
import 'market_references_spod.dart';
import 'search_stpod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final references = ref.watch(marketReferencesSpod);
  final assets = ref.watch(assetsSpod);
  final balances = ref.watch(balancesSpod);
  final search = ref.watch(searchStpod);
  final baseCurrency = ref.watch(baseCurrencyPod);
  final basePrices = ref.watch(basePricesSpod);

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

  basePrices.whenData((data) {
    final _basePrices = data.basePrices;

    if (items.isNotEmpty) {
      for (final item in items) {
        final index = items.indexOf(item);

        final baseBalance = calculateBaseBalance(
          accuracy: baseCurrency.accuracy.toInt(),
          assetSymbol: item.associateAsset,
          assetBalance: item.assetBalance,
          prices: _basePrices,
        );

        final assetPrice = _basePrices.firstWhere((element) {
          return element.assetSymbol == item.associateAsset;
        });

        final currentPrice = assetPrice.currentPrice;
        final dayPrice = assetPrice.dayPrice.price;

        final dayPriceChange = currentPrice - dayPrice;

        items[index] = item.copyWith(
          baseBalance: baseBalance,
          dayPriceChange: double.parse(
            dayPriceChange.toStringAsFixed(
              baseCurrency.accuracy.toInt(),
            ),
          ),
          dayPercentChange: assetPrice.dayPercentChange,
          lastPrice: assetPrice.currentPrice,
        );
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
